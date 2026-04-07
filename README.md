# AI agent

这是我长期使用 AI agent 时整理出来的两个本地提醒 skill，最初主要是因为我用 Codex 时遇到了两个很实际的问题。

AI agent 干活经常一跑就是很久。我可以先去做别的事，但又不知道它什么时候结束。这个时候如果任务做完能直接播一个 Windows 提示音，马上就能知道，不用一直盯着界面。

另一个办法是发邮件。邮件直接走公网，手机就能收到提醒。至于手机是静音、震动，还是带提示音，这个按你自己的手机设置来就行，实际用起来很方便。

## 现在包含的 skill

- `windows-task-notify`：任务结束后播放 Windows 系统提示音
- `smtp-task-notify`：任务结束后通过 SMTP 发邮件

## 适合怎么发

放 GitHub 最合适。现在这类 skill 更像“仓库里的一个文件夹”，适合按 GitHub 路径安装，也适合自己收藏、复用和继续改。

## 安装方式

发布到 GitHub 后，可以按仓库路径安装单个 skill。

```powershell
python <skill-installer>\scripts\install-skill-from-github.py --repo <you>/<repo> --path windows-task-notify
python <skill-installer>\scripts\install-skill-from-github.py --repo <you>/<repo> --path smtp-task-notify
```

装完后重启 Codex。

## 使用说明

- Windows 提示音 skill 不需要额外配置，装上就能用。
- 邮件 skill 需要准备 SMTP 配置和授权码。
- 如果你已经有 `config.json` 和 `credentials.xml`，直接复用就行，不必重新配。
