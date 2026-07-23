# Gordon — Claude Code plugin

Run **Gordon**, Datasharp's M&A pipeline copilot, inside Claude Code. The `/gordon`
skill works the pipeline in **Attio** (your own connected account, the single source of
truth) and **reads the data model live from Attio** — objects, attribute slugs, and the
current select/status option titles — so the data dictionary is never hardcoded. No
separate CLI, launcher, or `cloudflared`.

## Install (per user, one-time)

```text
/plugin marketplace add datasharphq/gordon-plugin
/plugin install gordon@datasharp
/mcp        # authorize attio + gdrive + Linear once (browser OAuth, as yourself)
```

Then run `/gordon:gordon` (or just ask Gordon to work the pipeline). Updates: the
maintainer bumps `version` in `.claude-plugin/plugin.json`; run `/plugin marketplace update`.

## What it is

The `/gordon` skill turns a Claude Code session into Gordon. It discovers the model from
Attio (`list-attribute-definitions` on `ma_deal` + `companies`), then works the pipeline:

- **Pipeline, contacts, knowledge, and email all live in Attio** — `ma_deal` (one record
  per target, the lifecycle `pipeline_status` + fit/outreach fields), `companies` (the
  entity master + classification), `people` (contacts), and **notes** attached to the
  `ma_deal` record (the knowledge base). Nothing lives in Google Drive/Sheets.
- **gdrive** is a utility only — for fetching external files an operator points you at
  (e.g. a Gemini/meeting transcript). It is not the knowledge store.
- **Linear** tracks pipeline work and email triage.

Access to the data is gated by your own Attio / Google / Linear OAuth (user-scoped) —
these are your accounts, not a shared mailbox. All M&A content lives in Attio
(access-controlled), not in this repo.

## Permissions

The plugin ships a `PreToolUse` hook (`hooks/`) that **auto-approves non-destructive,
read-only tools** so routine pipeline work doesn't prompt on every call:

- Auto-approved: Attio's read-only tools (`list-attribute-definitions`,
  `list-list-attribute-definitions`, `list-lists`, `search-records`, `list-records`,
  `list-records-in-list`, `get-records-by-ids`, `search-notes-by-metadata`,
  `get-note-body`, `search-emails-by-metadata`, `get-email-content`) and read-only gdrive
  fetches (`downloadFile`, `searchDriveFiles`, `readSpreadsheet`, `readDocument`).
- **Still prompt** (deliberately): every Attio write (`create-record`, `update-record`,
  `upsert-record`, `create-note`, …), every Linear tool, and any tool not listed above
  (fail-safe).

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
