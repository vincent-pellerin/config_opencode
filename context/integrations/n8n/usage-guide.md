# n8n Integration Usage Guide

## Quick Start

### 1. Load Configuration
```bash
# Load n8n configuration in your session
@~/.opencode/context/integrations/n8n/config.md
```

### 2. Test Connection
```bash
# Run connection test (script in ~/.opencode/bin/)
n8n-test
```

### 3. Generate New API Key (if needed)
1. Access: https://n8n.vpdata.fr
2. Login with: `galakbibi@gmail.com` / `bf*8!9aPqe2aSDN`
3. Go to Settings > n8n API
4. Create new API key
5. Update your `.env` file

## Common Debugging Tasks

### List All Workflows
```bash
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/workflows" | \
     jq '.data[] | {id: .id, name: .name, active: .active}'
```

### Check Failed Executions
```bash
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/executions?status=error" | \
     jq '.data[] | {id: .id, workflowId: .workflowId, error: .data.executionData.resultData.error}'
```

### Get Workflow Details
```bash
# Replace {workflow_id} with actual ID
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/workflows/{workflow_id}" | \
     jq '.data | {name: .name, nodes: (.nodes | length), active: .active}'
```

### Execute Workflow
```bash
# Replace {workflow_id} with actual ID
curl -X POST \
     -H "X-N8N-API-KEY: $N8N_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"data": {}}' \
     "https://n8n.vpdata.fr/api/v1/workflows/{workflow_id}/execute"
```

## Troubleshooting Workflows

### 1. Identify Problem Workflows
```bash
# Get workflows with recent failures
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/executions?status=error&limit=10" | \
     jq '.data | group_by(.workflowId) | map({workflowId: .[0].workflowId, failures: length}) | sort_by(.failures) | reverse'
```

### 2. Analyze Execution Errors
```bash
# Get detailed error for specific execution
execution_id="your_execution_id"
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/executions/$execution_id" | \
     jq '.data.executionData.resultData.runData | to_entries[] | select(.value[0].error) | {node: .key, error: .value[0].error.message}'
```

### 3. Check Node Performance
```bash
# Get execution timing for nodes
execution_id="your_execution_id"
curl -H "X-N8N-API-KEY: $N8N_API_KEY" \
     "https://n8n.vpdata.fr/api/v1/executions/$execution_id" | \
     jq '.data.executionData.resultData.runData | to_entries[] | {node: .key, duration: .value[0].executionTime}'
```

## Python Helper Functions

```python
import os
import requests
from typing import Dict, List, Optional
import json

class N8nDebugger:
    def __init__(self):
        self.base_url = "https://n8n.vpdata.fr/api/v1"
        self.api_key = os.getenv('N8N_API_KEY')
        if not self.api_key:
            raise ValueError("N8N_API_KEY environment variable not set")
        
        self.headers = {
            'X-N8N-API-KEY': self.api_key,
            'Content-Type': 'application/json'
        }
    
    def get_failed_workflows(self, limit: int = 20) -> List[Dict]:
        """Get workflows with recent failures"""
        response = requests.get(
            f"{self.base_url}/executions",
            headers=self.headers,
            params={'status': 'error', 'limit': limit}
        )
        response.raise_for_status()
        return response.json().get('data', [])
    
    def analyze_workflow_errors(self, workflow_id: str) -> Dict:
        """Analyze errors for a specific workflow"""
        # Get recent executions
        response = requests.get(
            f"{self.base_url}/executions",
            headers=self.headers,
            params={'workflowId': workflow_id, 'status': 'error', 'limit': 10}
        )
        response.raise_for_status()
        executions = response.json().get('data', [])
        
        error_summary = {
            'total_failures': len(executions),
            'error_patterns': {},
            'failing_nodes': {}
        }
        
        for execution in executions:
            execution_id = execution['id']
            
            # Get detailed execution data
            detail_response = requests.get(
                f"{self.base_url}/executions/{execution_id}",
                headers=self.headers
            )
            
            if detail_response.status_code == 200:
                detail_data = detail_response.json()
                run_data = detail_data.get('data', {}).get('executionData', {}).get('resultData', {}).get('runData', {})
                
                for node_name, node_data in run_data.items():
                    if node_data and len(node_data) > 0 and node_data[0].get('error'):
                        error_msg = node_data[0]['error'].get('message', 'Unknown error')
                        
                        # Count error patterns
                        if error_msg in error_summary['error_patterns']:
                            error_summary['error_patterns'][error_msg] += 1
                        else:
                            error_summary['error_patterns'][error_msg] = 1
                        
                        # Count failing nodes
                        if node_name in error_summary['failing_nodes']:
                            error_summary['failing_nodes'][node_name] += 1
                        else:
                            error_summary['failing_nodes'][node_name] = 1
        
        return error_summary
    
    def get_workflow_performance(self, workflow_id: str, limit: int = 10) -> Dict:
        """Analyze workflow performance"""
        response = requests.get(
            f"{self.base_url}/executions",
            headers=self.headers,
            params={'workflowId': workflow_id, 'limit': limit}
        )
        response.raise_for_status()
        executions = response.json().get('data', [])
        
        performance_data = {
            'total_executions': len(executions),
            'avg_duration': 0,
            'success_rate': 0,
            'durations': []
        }
        
        successful_executions = 0
        total_duration = 0
        
        for execution in executions:
            if execution.get('stoppedAt') and execution.get('startedAt'):
                duration = int(execution['stoppedAt']) - int(execution['startedAt'])
                performance_data['durations'].append(duration)
                total_duration += duration
            
            if execution.get('status') == 'success':
                successful_executions += 1
        
        if performance_data['durations']:
            performance_data['avg_duration'] = total_duration / len(performance_data['durations'])
        
        if performance_data['total_executions'] > 0:
            performance_data['success_rate'] = successful_executions / performance_data['total_executions']
        
        return performance_data

# Usage example
if __name__ == "__main__":
    debugger = N8nDebugger()
    
    # Get failed workflows
    failed = debugger.get_failed_workflows()
    print(f"Found {len(failed)} failed executions")
    
    # Analyze specific workflow
    if failed:
        workflow_id = failed[0]['workflowId']
        errors = debugger.analyze_workflow_errors(workflow_id)
        performance = debugger.get_workflow_performance(workflow_id)
        
        print(f"\nWorkflow {workflow_id} Analysis:")
        print(f"- Total failures: {errors['total_failures']}")
        print(f"- Success rate: {performance['success_rate']:.2%}")
        print(f"- Average duration: {performance['avg_duration']:.2f}ms")
        print(f"- Common errors: {list(errors['error_patterns'].keys())[:3]}")
```

## Bash Helper Functions

```bash
#!/bin/bash
# n8n debugging helper functions

# Source this file to use the functions
# source ~/.opencode/context/integrations/n8n/usage-guide.md

n8n_get_workflows() {
    local active_only="${1:-false}"
    local url="$N8N_API_URL/workflows"
    
    if [ "$active_only" = "true" ]; then
        url="$url?active=true"
    fi
    
    curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "$url" | \
        jq '.data[] | {id: .id, name: .name, active: .active, nodes: (.nodes | length)}'
}

n8n_get_failed_executions() {
    local limit="${1:-10}"
    
    curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \
        "$N8N_API_URL/executions?status=error&limit=$limit" | \
        jq '.data[] | {id: .id, workflowId: .workflowId, startedAt: .startedAt, error: .data.executionData.resultData.error.message}'
}

n8n_analyze_workflow() {
    local workflow_id="$1"
    
    if [ -z "$workflow_id" ]; then
        echo "Usage: n8n_analyze_workflow <workflow_id>"
        return 1
    fi
    
    echo "Analyzing workflow: $workflow_id"
    echo "================================"
    
    # Get workflow details
    echo "Workflow Details:"
    curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \
        "$N8N_API_URL/workflows/$workflow_id" | \
        jq '.data | {name: .name, active: .active, nodes: (.nodes | length), tags: .tags}'
    
    echo -e "\nRecent Executions:"
    curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \
        "$N8N_API_URL/executions?workflowId=$workflow_id&limit=5" | \
        jq '.data[] | {id: .id, status: .status, startedAt: .startedAt, duration: (if .stoppedAt and .startedAt then (.stoppedAt | tonumber) - (.startedAt | tonumber) else null end)}'
    
    echo -e "\nRecent Failures:"
    curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \
        "$N8N_API_URL/executions?workflowId=$workflow_id&status=error&limit=3" | \
        jq '.data[] | {id: .id, startedAt: .startedAt}'
}

n8n_execute_workflow() {
    local workflow_id="$1"
    local input_data="${2:-{}}"
    
    if [ -z "$workflow_id" ]; then
        echo "Usage: n8n_execute_workflow <workflow_id> [input_data]"
        return 1
    fi
    
    echo "Executing workflow: $workflow_id"
    curl -X POST \
        -H "X-N8N-API-KEY: $N8N_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"data\": $input_data}" \
        "$N8N_API_URL/workflows/$workflow_id/execute" | \
        jq '.data | {executionId: .executionId, status: .status}'
}

n8n_health_check() {
    echo "n8n Health Check"
    echo "================"
    
    # Check instance
    if curl -s "$N8N_BASE_URL/healthz" | grep -q '"status":"ok"'; then
        echo "✅ Instance healthy"
    else
        echo "❌ Instance unhealthy"
    fi
    
    # Check API key
    if curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_API_URL/workflows" | grep -q '"data"'; then
        echo "✅ API key valid"
    else
        echo "❌ API key invalid"
    fi
    
    # Get basic stats
    local workflow_count=$(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_API_URL/workflows" | jq '.data | length' 2>/dev/null || echo "0")
    local active_count=$(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_API_URL/workflows?active=true" | jq '.data | length' 2>/dev/null || echo "0")
    
    echo "📊 Workflows: $workflow_count total, $active_count active"
}

# Export functions
export -f n8n_get_workflows
export -f n8n_get_failed_executions
export -f n8n_analyze_workflow
export -f n8n_execute_workflow
export -f n8n_health_check
```

## Environment Setup

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# n8n Integration
export N8N_BASE_URL="https://n8n.vpdata.fr"
export N8N_API_URL="https://n8n.vpdata.fr/api/v1"
export N8N_USERNAME="galakbibi@gmail.com"
export N8N_PASSWORD="bf*8!9aPqe2aSDN"

# Load n8n helper functions
if [ -f ~/.opencode/context/integrations/n8n/usage-guide.md ]; then
    source ~/.opencode/context/integrations/n8n/usage-guide.md
fi

# Alias for quick access (n8n-test script is in ~/.opencode/bin/)
alias n8n-health='n8n_health_check'
```

---

**Remember**: Always generate a fresh API key when the current ones expire!