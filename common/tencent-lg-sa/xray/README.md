# Xray Docker Compose 配置

这个配置用于部署 Xray 代理服务，并通过 Traefik 进行反向代理和自动 HTTPS 证书管理。支持通过 GitHub Actions 自动化部署和环境变量配置。

## 使用前准备

### 1. 生成 UUID

首先需要生成一个 UUID 用于客户端认证：

```bash
# 使用 uuidgen 命令生成 UUID
uuidgen

# 或者使用在线工具生成
# https://www.uuidgenerator.net/
```

### 2. 配置环境变量

编辑 `.env` 文件，设置以下环境变量：

```bash
# Traefik 配置
TRAEFIK_DOMAIN=xray.yourdomain.com          # 你的域名
TRAEFIK_ACME_EMAIL=your-email@example.com   # Let's Encrypt 邮箱

# Xray 配置
XRAY_UUID=your-uuid-here                    # 生成的 UUID
XRAY_VLESS_PORT=10086                       # VLESS 端口
XRAY_VMESS_PORT=10087                       # VMess 端口
XRAY_VLESS_PATH=/vless                      # VLESS 路径
XRAY_VMESS_PATH=/vmess                      # VMess 路径

# 时区配置
TZ=Asia/Shanghai                            # 时区设置
```

**注意**：配置文件会根据环境变量自动生成，无需手动编辑 `xray/config.json`

### 3. 配置 Cloudflare（推荐）

为了隐藏真实服务器 IP 并提供更好的安全性，强烈建议使用 Cloudflare：

#### 3.1 Cloudflare 域名设置
1. 在 Cloudflare 中添加你的域名
2. 创建 A 记录指向你的服务器真实 IP
3. 确保代理状态为「已代理」（橙色云朵图标）
4. SSL/TLS 模式设置为「完全（严格）」

#### 3.2 Cloudflare 安全设置
1. **防火墙规则**：
   - 创建规则仅允许 Cloudflare IP 访问你的服务器
   - 阻止直接 IP 访问

2. **SSL/TLS 设置**：
   - 启用「始终使用 HTTPS」
   - 启用「HSTS」
   - 最小 TLS 版本设置为 1.2

#### 3.3 修改域名配置

编辑 `docker-compose.yaml` 文件：
- 将 `xray.yourdomain.com` 替换为你的实际域名
- 配置已包含 Cloudflare IP 白名单和真实 IP 获取

### 4. 确保 Traefik 网络存在

```bash
# 创建 traefik 网络（如果不存在）
docker network create traefik
```

## 启动服务

```bash
# 在当前目录下启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f xray
```

## 客户端配置

### VLESS 配置
- 协议：VLESS
- 地址：你的域名
- 端口：443（HTTPS）
- UUID：配置文件中设置的 UUID
- 流控：xtls-rprx-vision
- 传输协议：WebSocket
- 路径：/vless
- TLS：开启

### VMess 配置
- 协议：VMess
- 地址：你的域名
- 端口：443（HTTPS）
- UUID：配置文件中设置的 UUID
- 额外 ID：0
- 传输协议：WebSocket
- 路径：/vmess
- TLS：开启

## 服务器防火墙配置（使用 Cloudflare 时）

### UFW 防火墙规则示例

```bash
# 重置防火墙规则
sudo ufw --force reset

# 默认策略
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 允许 SSH（请根据实际端口修改）
sudo ufw allow 22/tcp

# 仅允许 Cloudflare IP 访问 HTTP/HTTPS
sudo ufw allow from 173.245.48.0/20 to any port 80
sudo ufw allow from 173.245.48.0/20 to any port 443
sudo ufw allow from 103.21.244.0/22 to any port 80
sudo ufw allow from 103.21.244.0/22 to any port 443
sudo ufw allow from 103.22.200.0/22 to any port 80
sudo ufw allow from 103.22.200.0/22 to any port 443
sudo ufw allow from 103.31.4.0/22 to any port 80
sudo ufw allow from 103.31.4.0/22 to any port 443
sudo ufw allow from 141.101.64.0/18 to any port 80
sudo ufw allow from 141.101.64.0/18 to any port 443
sudo ufw allow from 108.162.192.0/18 to any port 80
sudo ufw allow from 108.162.192.0/18 to any port 443
sudo ufw allow from 190.93.240.0/20 to any port 80
sudo ufw allow from 190.93.240.0/20 to any port 443
sudo ufw allow from 188.114.96.0/20 to any port 80
sudo ufw allow from 188.114.96.0/20 to any port 443
sudo ufw allow from 197.234.240.0/22 to any port 80
sudo ufw allow from 197.234.240.0/22 to any port 443
sudo ufw allow from 198.41.128.0/17 to any port 80
sudo ufw allow from 198.41.128.0/17 to any port 443
sudo ufw allow from 162.158.0.0/15 to any port 80
sudo ufw allow from 162.158.0.0/15 to any port 443
sudo ufw allow from 104.16.0.0/13 to any port 80
sudo ufw allow from 104.16.0.0/13 to any port 443
sudo ufw allow from 104.24.0.0/14 to any port 80
sudo ufw allow from 104.24.0.0/14 to any port 443
sudo ufw allow from 172.64.0.0/13 to any port 80
sudo ufw allow from 172.64.0.0/13 to any port 443
sudo ufw allow from 131.0.72.0/22 to any port 80
sudo ufw allow from 131.0.72.0/22 to any port 443

# 启用防火墙
sudo ufw enable
```

### 自动更新 Cloudflare IP 范围

为了简化 Cloudflare IP 范围的维护，提供了自动更新脚本：

```bash
# 运行自动更新脚本
./update-cloudflare-ips.sh

# 或者设置定期任务（每周更新一次）
# 编辑 crontab
crontab -e

# 添加以下行（每周日凌晨 2 点执行）
0 2 * * 0 /path/to/your/project/update-cloudflare-ips.sh >> /var/log/cloudflare-ip-update.log 2>&1
```

**注意**：运行脚本前请确保：
1. 你有 sudo 权限
2. 当前 SSH 连接稳定
3. 已备份重要的防火墙规则

## 注意事项

1. **使用 Cloudflare 时**：
   - 服务器防火墙必须配置为仅允许 Cloudflare IP 访问
   - 禁止直接通过 IP 访问服务器
   - 定期更新 Cloudflare IP 范围

2. **域名和证书**：
   - 域名必须通过 Cloudflare 代理
   - Traefik 需要正确配置 Let's Encrypt 证书解析器
   - SSL/TLS 模式必须设置为「完全（严格）」

3. **安全维护**：
   - 定期备份配置文件和日志
   - 建议定期更新 Xray 镜像版本
   - 监控访问日志，及时发现异常访问
   - 定期轮换 UUID

## 故障排除

### 基本故障排除

```bash
# 查看容器状态
docker-compose ps

# 查看详细日志
docker-compose logs xray

# 重启服务
docker-compose restart xray

# 停止服务
docker-compose down
```

### Cloudflare 相关故障排除

#### 1. 验证 Cloudflare 代理状态
```bash
# 检查域名是否通过 Cloudflare 代理
dig +short yourdomain.com
# 应该返回 Cloudflare IP，而不是你的真实服务器 IP

# 检查真实 IP 是否被隐藏
curl -I http://your-real-server-ip
# 应该无法访问或返回错误
```

#### 2. 检查防火墙配置
```bash
# 查看当前防火墙规则
sudo ufw status numbered

# 测试从非 Cloudflare IP 访问（应该被拒绝）
curl -I http://yourdomain.com
```

#### 3. 验证真实 IP 获取
```bash
# 查看 Traefik 日志中的客户端 IP
docker logs traefik | grep "ClientIP"

# 检查 Xray 访问日志中的真实 IP
tail -f ./xray/logs/access.log
```

#### 4. 常见问题解决

**问题：无法连接到服务**
- 检查 Cloudflare SSL/TLS 模式是否为「完全（严格）」
- 确认域名代理状态为橙色云朵
- 验证防火墙规则是否正确配置

**问题：证书错误**
- 确保 Traefik 能够正常申请 Let's Encrypt 证书
- 检查域名 DNS 解析是否正确
- 验证 Cloudflare SSL/TLS 设置

**问题：真实 IP 泄露**
- 检查是否有其他服务暴露在公网
- 确认防火墙规则覆盖所有端口
- 验证没有直接 IP 访问的可能性

#### 5. 安全检查清单

```bash
# 检查开放端口
sudo netstat -tlnp

# 验证只有必要的端口对外开放
sudo ufw status

# 检查是否有直接 IP 访问
curl -I http://your-real-ip:80
curl -I https://your-real-ip:443

# 验证 Cloudflare IP 范围是否最新
# 可以从 https://www.cloudflare.com/ips/ 获取最新 IP 范围
```