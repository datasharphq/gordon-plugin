# Gordon — Claude Code plugin

Gordon is Datasharp's M&A pipeline copilot, packaged as a Claude Code plugin. It works
the pipeline in **Attio** and **reads the data model live from Attio** (objects, fields,
statuses, allowed values) rather than bundling a copy — so it can't drift from the
workspace. The plugin carries only Gordon's behavior (workflows + email templates); the
data dictionary always comes from Attio.

## Install

```text
/plugin marketplace add datasharphq/gordon-plugin
/plugin install gordon@datasharp
```

Then run `/mcp` once to authorize the **attio**, **gdrive**, and **Linear** MCP servers
(browser OAuth, as yourself), and invoke with `/gordon:gordon` — or just ask Gordon to
work the pipeline. No tokens or env vars to set: Gordon discovers the pipeline model
through the `attio` connection you authorized.

See [`gordon-plugin/README.md`](gordon-plugin/README.md) for permissions, the
auto-approve hook, and org-wide settings.
