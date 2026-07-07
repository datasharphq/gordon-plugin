# Gordon — Claude Code plugin

Gordon is Datasharp's M&A pipeline copilot, packaged as a Claude Code plugin. It works
the pipeline in **Attio** and loads its detailed workflow skills (pipeline, research,
classification, outreach) **on demand from the Janus Studio** — the single source of
truth, so nothing is bundled here and it can't drift from the live agent.

## Install

```text
/plugin marketplace add datasharphq/gordon-plugin
/plugin install gordon@datasharp
```

Then run `/mcp` once to authorize the **attio**, **gdrive**, and **Linear** MCP servers
(browser OAuth, as yourself), and invoke with `/gordon:gordon` — or just ask Gordon to
work the pipeline.

Gordon fetches its workflow skills from the studio at runtime, authenticated with your
studio session, so set it once per session:

```bash
export JANUS_SESSION=<your janus_session cookie value from https://janus.datasharp.com>
```

(Sign in to the studio in your browser, then copy the `janus_session` cookie via DevTools
→ Application → Cookies. It's short-lived — re-copy if a fetch returns 401.)

See [`gordon-plugin/README.md`](gordon-plugin/README.md) for permissions, the
auto-approve hook, and org-wide settings.
