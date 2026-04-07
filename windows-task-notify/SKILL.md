---
name: windows-task-notify
description: Play a Windows notification sound after a task completes or when Codex needs to actively alert the user on a Windows machine. Use when the user asks for a task-done chime, a Windows prompt sound, or an audible completion reminder.
---

# Windows Task Notify

Use `scripts/play-windows-notify.ps1` as the last step after real work finishes.

## Quick Start

Run the script directly:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\play-windows-notify.ps1" -Sound Exclamation -Repeat 1
```

## Use Rules

- Play the sound only after the task, command, or verification step is actually done.
- Use `Exclamation` for normal completion.
- Use `Hand` or a higher `-Repeat` count only when the user wants a stronger warning.
- If the environment is not Windows, or audio output is unavailable, say so plainly instead of pretending the reminder worked.

## Parameters

- `-Sound`: `Default`, `Asterisk`, `Exclamation`, `Hand`, `Question`, or `Ok`
- `-Repeat`: how many times to play the sound
- `-DelayMs`: delay between repeats in milliseconds

## Resource

- `scripts/play-windows-notify.ps1`: plays a Windows system sound through the local Windows audio interface
