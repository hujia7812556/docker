# 多项目 Worktree 本地联调

首次更新本目录后，需要重建 PHP 与 Nginx 容器，使它们获得 Codex worktree 挂载：

```bash
docker compose up -d --force-recreate nginx php
```

使用 `scripts/worktree-dev` 注册任务。项目标识来自 `config/worktree-projects.sh`，任务名用于将后端、依赖库和前端 worktree 配对。

```bash
scripts/worktree-dev up mcn-api order-fix \
  --api /Users/hujia/.codex/worktrees/api-123/mcn-api.tiktoksaas.com \
  --lib mcnlib=/Users/hujia/.codex/worktrees/lib-456/mcnlib \
  --lib tkslib=/Users/hujia/.codex/worktrees/lib-789/tkslib
```

后端地址为：

```text
http://mcn-api--order-fix.localtest.me:8080
```

需要前端联调时附加 `--web` 和 `--port`。脚本会写入未纳入 Git 的 `.env.local`，并将 `/baseapi` 代理到同一任务的后端。

```bash
scripts/worktree-dev up affiliate-api order-fix \
  --api /Users/hujia/.codex/worktrees/api-123/affiliate-api.tiktoksaas.com \
  --web /Users/hujia/.codex/worktrees/web-123/affiliate.tiktoksaas.com \
  --port 5174
```

未传入某个 `--lib` 时，脚本会回退到 `/www` 中的主工作区库。共享 `vendor` 始终使用 `/www/vendor`，不需要为每个 worktree 运行 Composer。

常用命令：

```bash
scripts/worktree-dev list
scripts/worktree-dev cli mcn-api order-fix <yii 参数>
scripts/worktree-dev down mcn-api order-fix
```

`down` 只移除自动生成的 Nginx 路由和由脚本启动的 Vite 进程，不删除 worktree 或运行数据。
