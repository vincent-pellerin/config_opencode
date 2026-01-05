# n8n Integration Configuration

## Overview

Configuration for connecting to and debugging n8n workflows. This file provides connection details, API endpoints, and debugging patterns for n8n self-hosted community edition.

---

## Connection Configuration

### Instance Details
- **Base URL**: `https://n8n.vpdata.fr`
- **API Version**: `v1`
- **Edition**: Self-hosted Community Edition
- **Status**: ✅ Active and accessible

### API Endpoints
```bash
# Primary API endpoint
API_BASE_URL="https://n8n.vpdata.fr/api/v1"

# Alternative REST endpoint (if primary fails)
API_ALT_URL="https://n8n.vpdata.fr/rest"

# Health check endpoint
HEALTH_URL="https://n8n.vpdata.fr/healthz"
```

### Authentication Methods

#### API Key Authentication (Preferred)
```bash
# Header format for API calls
X-N8N-API-KEY: {api_key}

# Current API keys (check expiration)
# Key 1: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiMTFmZTJhOC04OGEzLTRhZDQtYTk3OC02ZGI5MTA4NTE2OTQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzYzMDQwNDQ4LCJleHAiOjE3NjU1ODA0MDB9.69dMHoT-VePMYwiqyQnq_LZWEJObxbqaDoXysjAde1w
# Key 2: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiMTFmZTJhOC04OGEzLTRhZDQtYTk3OC02ZGI5MTA4NTE2OTQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzYyOTc0MzQwfQ.r5o0LSg1Cr_A_WraUdMMjnyFVJU8d-AhzGJiM-6GJeg

# Note: Keys may be expired - use basic auth to generate new ones
```

#### Basic Authentication (Fallback)
```bash
# For web interface access and API key generation
USERNAME="galakbibi@gmail.com"
PASSWORD="bf*8!9aPqe2aSDN"

# Usage in curl
curl -u "galakbibi@gmail.com:bf*8!9aPqe2aSDN" "https://n8n.vpdata.fr"
```

## Environment Variables

Add these to your global `.env` file:

```bash
# n8n Configuration
N8N_BASE_URL="https://n8n.vpdata.fr"
N8N_API_URL="https://n8n.vpdata.fr/api/v1"
N8N_API_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiMTFmZTJhOC04OGEzLTRhZDQtYTk3OC02ZGI5MTA4NTE2OTQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzYzMDQwNDQ4LCJleHAiOjE3NjU1ODA0MDB9.69dMHoT-VePMYwiqyQnq_LZWEJObxbqaDoXysjAde1w"

# Basic Auth (for API key generation)
N8N_USERNAME="galakbibi@gmail.com"
N8N_PASSWORD="bf*8!9aPqe2aSDN"
```

## API Usage Patterns

### Common API Calls

#### Get All Workflows
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     -H "Content-Type: application/json" \
     "${N8N_API_URL}/workflows"
```

#### Get Active Workflows
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     -H "Content-Type: application/json" \
     "${N8N_API_URL}/workflows?active=true"
```

#### Get Workflow by ID
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     -H "Content-Type: application/json" \
     "${N8N_API_URL}/workflows/{workflow_id}"
```

#### Get Workflow Executions
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     -H "Content-Type: application/json" \
     "${N8N_API_URL}/executions?workflowId={workflow_id}"
```

#### Execute Workflow
```bash
curl -X POST \
     -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     -H "Content-Type: application/json" \
     -d '{"data": {}}' \
     "${N8N_API_URL}/workflows/{workflow_id}/execute"
```

### Error Handling Patterns

#### Check API Key Validity
```bash
# Test API key with simple request
response=$(curl -s -H "X-N8N-API-KEY: ${N8N_API_KEY}" "${N8N_API_URL}/workflows")

if echo "$response" | grep -q "unauthorized"; then
    echo "❌ API key expired or invalid"
    echo "💡 Generate new key via web interface"
else
    echo "✅ API key valid"
fi
```

#### Fallback to Basic Auth
```bash
# If API key fails, use basic auth
curl -u "${N8N_USERNAME}:${N8N_PASSWORD}" "${N8N_BASE_URL}/api/v1/workflows"
```

## Debugging Workflows

### Common Debugging Commands

#### List All Workflows with Status
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     "${N8N_API_URL}/workflows" | \
     jq '.data[] | {id: .id, name: .name, active: .active, nodes: (.nodes | length)}'
```

#### Get Failed Executions
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     "${N8N_API_URL}/executions?status=error" | \
     jq '.data[] | {id: .id, workflowId: .workflowId, status: .status, startedAt: .startedAt}'
```

#### Get Execution Details
```bash
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     "${N8N_API_URL}/executions/{execution_id}" | \
     jq '.data.executionData'
```

### Workflow Analysis Patterns

#### Node Error Analysis
```bash
# Get workflow with error details
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     "${N8N_API_URL}/executions/{execution_id}" | \
     jq '.data.executionData.resultData.runData | to_entries[] | select(.value[0].error) | {node: .key, error: .value[0].error}'
```

#### Performance Analysis
```bash
# Get execution timing
curl -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
     "${N8N_API_URL}/executions/{execution_id}" | \
     jq '.data | {duration: (.stoppedAt | tonumber) - (.startedAt | tonumber), status: .status}'
```

## Troubleshooting

### Common Issues and Solutions

#### 1. API Key Expired
**Symptoms**: `{"message":"unauthorized"}` responses
**Solution**: 
1. Access web interface with basic auth
2. Go to Settings > n8n API
3. Create new API key
4. Update environment variables

#### 2. Connection Refused
**Symptoms**: Connection timeout or refused
**Solution**:
1. Check instance status: `curl -I https://n8n.vpdata.fr`
2. Verify VPN/network access
3. Check Docker container status on server

#### 3. Wrong API Endpoint
**Symptoms**: `{"message":"not found"}` responses
**Solution**:
1. Try alternative endpoint: `/rest` instead of `/api/v1`
2. Check n8n version compatibility
3. Verify endpoint in web interface

### Quick Health Check Commands

```bash
# Test instance accessibility
curl -s -I "https://n8n.vpdata.fr" | grep -q "200" && echo "✅ Instance accessible" || echo "❌ Instance not accessible"

# Test health endpoint
curl -s "https://n8n.vpdata.fr/healthz" | grep -q '"status":"ok"' && echo "✅ Health OK" || echo "❌ Health check failed"

# Test API key validity
curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "https://n8n.vpdata.fr/api/v1/workflows" | grep -q '"data"' && echo "✅ API key valid" || echo "❌ API key invalid"

# Get basic stats
echo "📊 Workflows: $(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" "https://n8n.vpdata.fr/api/v1/workflows" | jq '.data | length' 2>/dev/null || echo '0') total"
```

## Security Considerations

### API Key Management
- **Rotation**: Rotate API keys regularly (monthly recommended)
- **Scope**: Use minimal required permissions
- **Storage**: Store in environment variables, never in code
- **Monitoring**: Monitor API key usage for anomalies

### Network Security
- **HTTPS**: Always use HTTPS endpoints
- **VPN**: Consider VPN access for production instances
- **Rate Limiting**: Respect API rate limits
- **Logging**: Monitor API access logs

## Integration Examples

### Python Integration
```python
import os
import requests
from typing import Dict, List, Optional

class N8nClient:
    def __init__(self):
        self.base_url = os.getenv('N8N_API_URL', 'https://n8n.vpdata.fr/api/v1')
        self.api_key = os.getenv('N8N_API_KEY')
        self.headers = {
            'X-N8N-API-KEY': self.api_key,
            'Content-Type': 'application/json'
        }
    
    def get_workflows(self, active_only: bool = False) -> List[Dict]:
        """Get all workflows or only active ones"""
        url = f"{self.base_url}/workflows"
        if active_only:
            url += "?active=true"
        
        response = requests.get(url, headers=self.headers)
        response.raise_for_status()
        return response.json().get('data', [])
    
    def get_workflow_executions(self, workflow_id: str, limit: int = 10) -> List[Dict]:
        """Get recent executions for a workflow"""
        url = f"{self.base_url}/executions"
        params = {'workflowId': workflow_id, 'limit': limit}
        
        response = requests.get(url, headers=self.headers, params=params)
        response.raise_for_status()
        return response.json().get('data', [])
    
    def execute_workflow(self, workflow_id: str, data: Dict = None) -> Dict:
        """Execute a workflow with optional input data"""
        url = f"{self.base_url}/workflows/{workflow_id}/execute"
        payload = {'data': data or {}}
        
        response = requests.post(url, headers=self.headers, json=payload)
        response.raise_for_status()
        return response.json()
```

### Bash Integration
```bash
#!/bin/bash
# n8n Workflow Manager

N8N_API_URL="${N8N_API_URL:-https://n8n.vpdata.fr/api/v1}"

n8n_api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    
    if [ -z "$N8N_API_KEY" ]; then
        echo "Error: N8N_API_KEY not set" >&2
        return 1
    fi
    
    local curl_args=(
        -X "$method"
        -H "X-N8N-API-KEY: $N8N_API_KEY"
        -H "Content-Type: application/json"
    )
    
    if [ -n "$data" ]; then
        curl_args+=(-d "$data")
    fi
    
    curl -s "${curl_args[@]}" "$N8N_API_URL$endpoint"
}

# Usage examples
list_workflows() {
    n8n_api_call "GET" "/workflows" | jq '.data[] | {id: .id, name: .name, active: .active}'
}

execute_workflow() {
    local workflow_id="$1"
    local input_data="${2:-{}}"
    n8n_api_call "POST" "/workflows/$workflow_id/execute" "{\"data\": $input_data}"
}
```

## Maintenance Tasks

### Regular Maintenance
1. **Weekly**: Check API key expiration
2. **Monthly**: Rotate API keys
3. **Quarterly**: Review workflow performance
4. **As needed**: Update connection details

### Monitoring Setup
- Monitor workflow execution success rates
- Track API response times
- Alert on authentication failures
- Log unusual API usage patterns

## Related Tools

### Test Script
- **Location**: `~/.opencode/bin/n8n-test`
- **Purpose**: Test n8n connectivity and configuration
- **Usage**: `n8n-test` (if ~/.opencode/bin is in PATH)

### Usage Guide
- **Location**: `~/.opencode/context/integrations/n8n/usage-guide.md`
- **Purpose**: Detailed usage examples and helper functions

---

**Last Updated**: 2026-01-05
**Version**: 1.1
**Maintainer**: Development Team