# 多项目 Codex Worktree 联调

首次启用或更新 Compose 后，重建容器以挂载 `~/.codex/worktrees`：

```bash
docker compose up -d --force-recreate nginx php
```

如果 Codex 在 Docker 尚未启动时创建了 worktree，设置脚本会成功写入路由但不会 reload；启动容器后执行：

```bash
worktree-dev reload
```

共享 Composer 依赖固定使用 `/www/vendor`，无需为每个 worktree 执行 `composer install`。脚本在 API worktree 父目录创建仅供容器解析的 `vendor` 与依赖库链接，项目源码保持原有相对路径加载方式。

## Codex 本地环境配置

在每个项目的 Codex「本地环境」填写设置、清理脚本。Codex 会提供 `$CODEX_WORKTREE_PATH`。

### API 设置脚本

在 `affiliate-api.tiktoksaas.com` 填入：

```zsh
#!/bin/zsh
set -euo pipefail
WORKTREE_DEV="/Users/hujia/myproject/docker/xlzy/php-nginx-tk/scripts/worktree-dev"
WORKTREE_ID="$(basename "$(dirname "$CODEX_WORKTREE_PATH")")"
TASK_NAME="${WORKTREE_TASK_NAME:-}"
if [[ -z "$TASK_NAME" ]]; then
  TASK_NAME="$(osascript -e 'text returned of (display dialog "请输入任务名（例如 lion-ux）" default answer "")')"
fi
"$WORKTREE_DEV" api-up affiliate-api "$WORKTREE_ID" --api "$CODEX_WORKTREE_PATH" --task "$TASK_NAME"
```

`mcn-api.tiktoksaas.com`、`cmc-api.tiktoksaas.com` 使用相同脚本，仅将项目标识替换为 `mcn-api`、`cmc-api`。

API 清理脚本：

```zsh
#!/bin/zsh
WORKTREE_DEV="/Users/hujia/myproject/docker/xlzy/php-nginx-tk/scripts/worktree-dev"
WORKTREE_ID="$(basename "$(dirname "$CODEX_WORKTREE_PATH")")"
"$WORKTREE_DEV" api-down affiliate-api "$WORKTREE_ID" || true
```

### 库设置脚本

在 `tkslib` 填入：

```zsh
#!/bin/zsh
set -euo pipefail
WORKTREE_DEV="/Users/hujia/myproject/docker/xlzy/php-nginx-tk/scripts/worktree-dev"
WORKTREE_ID="$(basename "$(dirname "$CODEX_WORKTREE_PATH")")"
TASK_NAME="${WORKTREE_TASK_NAME:-}"
if [[ -z "$TASK_NAME" ]]; then
  TASK_NAME="$(osascript -e 'text returned of (display dialog "请输入任务名（例如 lion-ux）" default answer "")')"
fi
"$WORKTREE_DEV" lib-up tkslib "$WORKTREE_ID" --path "$CODEX_WORKTREE_PATH" --task "$TASK_NAME"
```

`mcnlib`、`cmclib` 使用相同脚本，替换库名。库清理脚本：

```zsh
#!/bin/zsh
WORKTREE_DEV="/Users/hujia/myproject/docker/xlzy/php-nginx-tk/scripts/worktree-dev"
WORKTREE_ID="$(basename "$(dirname "$CODEX_WORKTREE_PATH")")"
"$WORKTREE_DEV" lib-down tkslib "$WORKTREE_ID" || true
```

## 完整流程

1. 创建 API worktree，弹窗输入任务名：自动注册 API 路由。
2. 创建需要修改的库 worktree，在同一弹窗输入**相同任务名**：自动注册该库并自动关联同任务名 API。
3. 执行 `worktree-dev list` 查看两个区块：`API worktree：` 和 `库 worktree：`。API 每行依次为工作区、路径、任务名、关联库、注册时间。
4. 未在创建时填写任务名时，可手工标注：

   ```bash
   worktree-dev set-task affiliate-api <api-id> lion-ux
   ```

   `worktree-dev list` 会显示任务名和注册时间。也可以手工注册时直接使用 `--task lion-ux`。

5. 同名自动关联不符合预期时，可显式绑定本期开发使用的库：

   ```bash
   worktree-dev bind affiliate-api lion-ux --lib tkslib=lion-ux
   worktree-dev bind mcn-api lion-ux --lib mcnlib=lion-ux --lib tkslib=lion-ux
   worktree-dev bind cmc-api lion-ux --lib cmclib=lion-ux --lib tkslib=lion-ux
   ```

6. 访问 `http://<项目标识>--<任务名>.localtest.me:8080`，例如 `http://affiliate-api--lion-ux.localtest.me:8080`。未设置任务名的旧记录兼容使用 `<api-id>`。
7. Codex 删除 API worktree 时自动移除路由和链接。删除仍被绑定的库时清理会安全失败，提示先清理或改绑 API。

常用命令：

```bash
worktree-dev list
worktree-dev cli mcn-api lion-ux <yii 参数>
worktree-dev api-down mcn-api lion-ux
worktree-dev lib-down tkslib lion-ux
```
