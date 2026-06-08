# Gordon — Claude Code plugin

Gordon is Datasharp's M&A pipeline copilot, packaged as a Claude Code plugin.

## Install

```text
/plugin marketplace add datasharphq/gordon-plugin
/plugin install gordon@datasharp
```

Then run `/mcp` once to authorize the **gdrive** + **Linear** MCP servers (browser OAuth, as yourself), and invoke with `/gordon:gordon` — or just ask Gordon to work the pipeline.

See [`gordon-plugin/README.md`](gordon-plugin/README.md) for permissions, the auto-approve hook, and org-wide settings.
