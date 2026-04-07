# codex-notify-skills

两个本地提醒 skill：

- `windows-task-notify`：任务结束后播放 Windows 系统提示音
- `smtp-task-notify`：任务结束后通过 SMTP 发邮件

## 适合怎么发

放 GitHub 最合适。现在这类 skill 更像“仓库里的一个文件夹”，适合按 GitHub 路径安装和自己收藏复用。

## 安装方式

发布到 GitHub 后，可以按仓库路径安装单个 skill。

例子：

```powershell
python <skill-installer>\scripts\install-skill-from-github.py --repo <you>/<repo> --path windows-task-notify
python <skill-installer>\scripts\install-skill-from-github.py --repo <you>/<repo> --path smtp-task-notify
```

装完后重启 Codex。

## 你还要做的事

- Windows 提示音 skill 不需要额外配置。
- 邮件 skill 需要准备 SMTP 配置和授权码。
- 如果你已经有 `config.json` 和 `credentials.xml`，直接复用就行，不必重新配。
