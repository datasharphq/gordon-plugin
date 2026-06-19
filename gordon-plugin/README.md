# Gordon — Claude Code plugin

Run **Gordon**, Datasharp's M&A pipeline copilot, inside Claude Code. The `/gordon`
skill works the pipeline in the **Twenty CRM** (the single source of truth) and loads its
live operating **playbook from the CRM** through the bundled **gordon-crm** MCP server —
no separate CLI, launcher, or `cloudflared`.

## Install (per user, one-time)

```text
/plugin marketplace add datasharphq/gordon-plugin
/plugin install gordon@datasharp
/mcp        # authorize gordon-crm + gdrive + Linear once (browser OAuth, as yourself)
```

Then run `/gordon:gordon` (or just ask Gordon to work the pipeline). Updates: the
maintainer bumps `version` in `.claude-plugin/plugin.json`; run `/plugin marketplace update`.

## What it is

The `/gordon` skill turns a Claude Code session into Gordon. On start it fetches its
playbook (two `Gordon Playbook — …` notes) from the Twenty CRM, then works the pipeline:

- **Pipeline, contacts, knowledge, and email all live in the Twenty CRM** (`companies`,
  `people`, `notes`, `messages`). Nothing lives in Google Drive/Sheets.
- **gdrive** is a utility only — for fetching external files an operator points you at
  (e.g. a Gemini/meeting transcript). It is not the knowledge store.
- **Linear** tracks pipeline work and email triage.

Access to the data is gated by your own CRM / Google / Linear OAuth (user-scoped). The
playbook and all M&A content live in the CRM (access-controlled) — not in this repo.

## Permissions

The plugin ships a `PreToolUse` hook (`hooks/`) that **auto-approves non-destructive,
read-only tools** so routine pipeline work doesn't prompt on every call:

- Auto-approved: the CRM discovery tools (`get_tool_catalog`, `learn_tools`,
  `list_object_metadata_names`, `list_skills`) and read-only gdrive fetches
  (`downloadFile`, `searchDriveFiles`, `readSpreadsheet`, `readDocument`).
- **Still prompt** (deliberately): the CRM `execute_tool` (it performs both reads and
  writes), every Linear tool, and any tool not listed above (fail-safe).

This activates automatically for everyone who installs the plugin — no per-user settings
edit. A hook `allow` can **never** override a permissions `deny`, so the next section can
hard-block dangerous tools without the hook getting in the way.

### Optional: hard-block dangerous tools org-wide

To make destructive actions impossible (not just prompted) across the org, deploy a
managed settings file via MDM. On macOS:
`/Library/Application Support/ClaudeCode/managed-settings.json`

```json
{
  "permissions": {
    "deny": [
      "mcp__gdrive__sendEmail",
      "mcp__gdrive__createDraft",
      "mcp__gdrive__deleteFile"
    ]
  }
}
```

Managed settings have the highest precedence and can't be overridden by users or hooks.
