---
name: smtp-task-notify
description: Send a task-completion email through SMTP after Codex finishes actual work or a long-running command. Use when the user wants a QQ mailbox reminder, an SMTP email notification, or a full result summary sent to an inbox after the task completes.
---

# SMTP Task Notify

Use `scripts/send-task-email.ps1` to send the final result by email after real work finishes.

## Quick Start

If an existing SMTP config and credential file already exist, reuse them first. In this user's setup, that may already be the pair inside `codex-rule`.

Dry run first:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\send-task-email.ps1" -Subject "Task done" -Body "Full result here" -ConfigPath "<config.json>" -CredentialPath "<credentials.xml>" -DryRun
```

Then remove `-DryRun` to send for real.

## Setup

If you need a fresh setup:

1. Copy `references/config.example.json` to a writable config path, or let `scripts/setup-smtp-credential.ps1` create `config.local.json` for you.
2. Edit the sender, recipient, and SMTP host settings.
3. Save the SMTP auth code with `scripts/setup-smtp-credential.ps1`.

For QQ Mail, keep `smtp.host = smtp.qq.com` and use the SMTP auth code, not the web login password.

## Use Rules

- Send the email only after the real task is complete.
- Put the actual result in the body, not just "done".
- Use `-BodyFile` for longer logs or summaries.
- If sending fails, show the exact error and the likely fix.
- Reuse an existing `config.json` and `credentials.xml` pair when one is already available.

## Resources

- `scripts/send-task-email.ps1`: sends the message
- `scripts/setup-smtp-credential.ps1`: creates a local credential file for SMTP
- `references/config.example.json`: starting template for SMTP config
