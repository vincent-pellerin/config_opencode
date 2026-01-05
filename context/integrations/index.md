# Integrations Index

## Overview

Configuration files for external service integrations and API connections.

---

## Available Integrations

### n8n Workflow Automation
- **File**: `n8n/config.md`
- **Purpose**: n8n API connection and workflow debugging
- **Instance**: https://n8n.vpdata.fr (self-hosted community edition)
- **Status**: ✅ Active
- **Use Cases**: 
  - Workflow debugging and monitoring
  - API automation and integration
  - Process orchestration

### Triggers
- n8n workflow debugging
- automation troubleshooting
- API integration issues
- workflow performance analysis

## Usage Pattern

```bash
# Load n8n integration config when needed
@~/.opencode/context/integrations/n8n/config.md
```

## Dependencies

- Global environment variables (`.env`)
- Network access to service endpoints
- Valid authentication credentials

---

**Last Updated**: 2026-01-05