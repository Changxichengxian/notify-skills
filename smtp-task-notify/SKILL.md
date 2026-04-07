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

### Reuse an existing SMTP setup

If a working `config.json` and `credentials.xml` already exist, prefer reusing them instead of creating new ones.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\send-task-email.ps1" -Subject "Task done" -Body "Full result here" -ConfigPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\config.json" -CredentialPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\credentials.xml" -DryRun
```

If the dry run looks correct, remove `-DryRun`.

### Create a fresh local setup

If you need a fresh setup:

1. Run `scripts/setup-smtp-credential.ps1`.
2. Let it create `config.local.json` and `credentials.local.xml`, or pass custom paths.
3. Edit the config fields.
4. Save the SMTP auth code with the setup script.
5. Dry run `send-task-email.ps1` before sending a real message.

This skill uses these default local files when you do not pass custom paths:

- `<skill-dir>\config.local.json`
- `<skill-dir>\credentials.local.xml`

The most important config fields are:

- `smtp.host`
- `smtp.port`
- `smtp.useSsl`
- `mail.from`
- `mail.to`
- `subjectPrefix`

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
