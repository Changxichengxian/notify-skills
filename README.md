# notify-skills

These are two local notification skills I put together after using AI agents for a long time, especially Codex.

AI agents often run for a long time. I may step away and do something else, but I still want to know exactly when a task is finished. A Windows notification sound solves that problem directly.

The other option is email. Email goes through the public internet, so my phone can notify me directly. Whether the phone is silent, vibrates, or rings depends on my phone settings, which makes this very convenient in practice.

这是我长期使用 AI agent 时整理出来的两个本地提醒 skill，最初主要是因为我用 Codex 时遇到了两个很实际的问题。

AI agent 干活经常一跑就是很久。我可以先去做别的事，但又不知道它什么时候结束。这个时候如果任务做完能直接播一个 Windows 提示音，马上就能知道，不用一直盯着界面。

另一个办法是发邮件。邮件直接走公网，手机就能收到提醒。至于手机是静音、震动，还是带提示音，这个按你自己的手机设置来就行，实际用起来很方便。

## Included Skills

- `windows-task-notify`: play a Windows system notification sound after a task finishes
- `smtp-task-notify`: send an email through SMTP after a task finishes

## 现在包含的 skill

- `windows-task-notify`：任务结束后播放 Windows 系统提示音
- `smtp-task-notify`：任务结束后通过 SMTP 发邮件

## Installation

Install each skill by repository path after publishing to GitHub:

```powershell
python <skill-installer>\scripts\install-skill-from-github.py --repo Changxichengxian/codex-notify-skills --path windows-task-notify
python <skill-installer>\scripts\install-skill-from-github.py --repo Changxichengxian/codex-notify-skills --path smtp-task-notify
```

Restart Codex after installation.

## 安装方式

发布到 GitHub 后，可以按仓库路径安装单个 skill。

```powershell
python <skill-installer>\scripts\install-skill-from-github.py --repo Changxichengxian/codex-notify-skills --path windows-task-notify
python <skill-installer>\scripts\install-skill-from-github.py --repo Changxichengxian/codex-notify-skills --path smtp-task-notify
```

装完后重启 Codex。

## SMTP Skill Setup

### Option A: reuse an existing SMTP setup

If you already have a working SMTP setup, reuse it directly. In your case, that may be the pair inside `C:\Users\28111\Desktop\ARBATOS\local\codex-rule`.

Dry run first:

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\send-task-email.ps1" `
  -Subject "test" `
  -Body "hello" `
  -ConfigPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\config.json" `
  -CredentialPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\credentials.xml" `
  -DryRun
```

If the output looks correct, remove `-DryRun` and send a real message.

### Option B: create a fresh local SMTP setup

Run:

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\setup-smtp-credential.ps1"
```

This creates or uses:

- `.\smtp-task-notify\config.local.json`
- `.\smtp-task-notify\credentials.local.xml`

Then edit `config.local.json` and set these fields:

- `smtp.host`: SMTP server, for QQ Mail use `smtp.qq.com`
- `smtp.port`: usually `587`
- `smtp.useSsl`: usually `true`
- `mail.from`: the sender mailbox
- `mail.to`: one or more recipient mailboxes
- `subjectPrefix`: optional subject prefix such as `[Codex]`

Important:

- Use the SMTP authorization code or app password, not the normal web login password.
- For QQ Mail, enable SMTP service in the mailbox settings first, then copy the authorization code.
- Always test with `-DryRun` before sending a real message.

Example dry run with local config:

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\send-task-email.ps1" `
  -Subject "test" `
  -Body "hello" `
  -DryRun
```

Then remove `-DryRun` to send for real.

## 邮件 skill 怎么配置

### 方案 A：直接复用现成配置

如果你已经有一套能发信的 SMTP 配置，直接复用最省事。对你现在这套来说，最可能就是 `C:\Users\28111\Desktop\ARBATOS\local\codex-rule` 里的那两个文件。

先干跑一遍：

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\send-task-email.ps1" `
  -Subject "test" `
  -Body "hello" `
  -ConfigPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\config.json" `
  -CredentialPath "C:\Users\28111\Desktop\ARBATOS\local\codex-rule\credentials.xml" `
  -DryRun
```

如果输出看着正常，就把 `-DryRun` 去掉，直接发真实邮件。

### 方案 B：新建一套本地配置

运行：

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\setup-smtp-credential.ps1"
```

它会创建或者使用这两个文件：

- `.\smtp-task-notify\config.local.json`
- `.\smtp-task-notify\credentials.local.xml`

然后把 `config.local.json` 里的字段填清楚：

- `smtp.host`：SMTP 服务器，QQ 邮箱就填 `smtp.qq.com`
- `smtp.port`：一般填 `587`
- `smtp.useSsl`：一般填 `true`
- `mail.from`：发件邮箱
- `mail.to`：收件邮箱，可以放一个或多个
- `subjectPrefix`：可选，邮件标题前缀，比如 `[Codex]`

注意：

- 不要填网页登录密码，要填 SMTP 授权码，或者应用专用密码。
- 如果你用的是 QQ 邮箱，要先在邮箱设置里开 SMTP 服务，再复制授权码。
- 真发之前先用 `-DryRun` 测一下。

本地配置的干跑例子：

```powershell
powershell -ExecutionPolicy Bypass -File ".\smtp-task-notify\scripts\send-task-email.ps1" `
  -Subject "test" `
  -Body "hello" `
  -DryRun
```

确认没问题后，把 `-DryRun` 去掉就行。

## Usage Notes

- The Windows sound skill needs no extra setup. Install it and use it directly.
- The email skill needs SMTP config plus an authorization code or app password.
- If you already have working `config.json` and `credentials.xml`, reuse them.

## 使用说明

- Windows 提示音 skill 不需要额外配置，装上就能用。
- 邮件 skill 需要准备 SMTP 配置和授权码。
- 如果你已经有 `config.json` 和 `credentials.xml`，直接复用就行，不必重新配。
