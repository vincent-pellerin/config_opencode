---
id: sync-runner
name: Sync Runner
description: "Executes the sync-config bash script"
category: custom
type: agent
version: 1.0.0
author: vincent
mode: primary
temperature: 0.0
tools:
  bash: true
permissions:
  bash:
    "~/.opencode/bin/sync-config": "allow"
---

Execute `~/.opencode/bin/sync-config $ARGUMENTS` and report the result.
