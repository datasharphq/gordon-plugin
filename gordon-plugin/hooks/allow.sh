#!/usr/bin/env sh
# gordon plugin — auto-approve non-destructive, read-only MCP tools so they don't
# prompt (Attio reads + gdrive fetches). Only the safe tools are wired to this hook
# (see the matchers in hooks.json); every Attio write (create-/update-/upsert-record,
# create-note) and gdrive sendEmail/createDraft/deleteFile are deliberately NOT
# matched, so they still go through the normal permission prompt. Emitting this JSON
# on stdout is how a PreToolUse hook tells Claude Code to allow the call.
#
# Safety: a hook "allow" can never override a permissions `deny` rule — deny
# always wins — so an org can still hard-block tools via managed-settings.json.
printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"gordon plugin: non-destructive read-only operation auto-approved"}}'
