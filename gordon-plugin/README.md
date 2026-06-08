# Gordon — Claude Code plugin

Run **Gordon**, Datasharp's M&A pipeline copilot, inside Claude Code. The `/gordon`
skill reads its live operating instructions from the `M&A Agent` Google Drive folder
through the bundled **gdrive** + **Linear** MCP servers — no separate CLI, launcher, or
`cloudflared`.

## Install (per user, one-time)

```text
/plugin marketplace add datasharphq/ds-gordon
/plugin install gordon@datasharp
/mcp        # authorize gdrive + Linear once (browser OAuth, as yourself)
```

Then run `/gordon:gordon` (or just ask Gordon to work the pipeline). Updates: the
maintainer bumps `version` in `.claude-plugin/plugin.json`; run `/plugin marketplace update`.

## Permissions

The plugin ships a `PreToolUse` hook (`hooks/`) that **auto-approves non-destructive
gdrive tools** so routine pipeline work doesn't prompt on every call:

- Auto-approved: `downloadFile`, `searchDriveFiles`, `readSpreadsheet`, `readDocument`,
  `createFile`, `updateFile`, `createDocument`, `replaceDocumentWithMarkdown`,
  `createSpreadsheet`, `writeSpreadsheet`, `appendRows`.
- **Still prompt** (deliberately, not matched by the hook): `sendEmail`, `createDraft`,
  `deleteFile`, and any tool not listed above (fail-safe). Linear tools also still prompt.

This activates automatically for everyone who installs the plugin — no per-user settings
edit. A hook `allow` can **never** override a permissions `deny`, so the next section can
hard-block the dangerous tools without the hook getting in the way.

### Optional: hard-block the dangerous tools org-wide

To make `sendEmail` / `createDraft` / `deleteFile` impossible (not just prompted) across
the org, deploy a managed settings file via MDM. On macOS:
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

## What it is

The `/gordon` skill turns a Claude Code session into Gordon by loading its live operating
instructions from a Google Drive folder via the bundled gdrive MCP server, then working the
M&A pipeline (a Google Sheet) and knowledge base. The prompt's single source of truth lives
in Drive (access-controlled) — it is not stored in this repo. Access to the data is gated by
your own Google/Linear OAuth (user-scoped) and the Drive folder's sharing.
