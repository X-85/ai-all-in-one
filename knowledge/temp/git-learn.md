# Git 学习总结

> 本文档记录通过实践学到的 Git 知识，特别是 SSH 和 HTTPS 认证的区别

## 背景

在学习使用 GitHub 同步知识库的过程中，遇到了一些认证和推送问题，本文记录这些经验。

## 核心知识点

### 1. Git 远程仓库地址格式

GitHub 提供两种远程地址：

```bash
# HTTPS 格式
https://github.com/用户名/仓库名.git

# SSH 格式
git@github.com:用户名/仓库名.git
```

切换命令：
```bash
git remote set-url origin <新地址>
```

### 2. HTTPS 认证方式

#### 早期方式（已废弃）
- 用户名 + 密码
- ❌ GitHub 已不再支持

#### 现代方式：Personal Access Token (PAT)
- 在 GitHub Settings → Developer settings → Personal access tokens 生成
- 推送时用 token 代替密码
- 或者用 URL 方式：`https://<token>@github.com/...`

**安全提示**：token 等同于密码，绝对不能分享给他人或 AI 助手。

### 3. SSH 认证方式（推荐）

#### 优势
- ✅ 不需要输入用户名密码
- ✅ 比 HTTPS 更安全
- ✅ 配置一次，永久使用
- ✅ 不需要管理 token

#### 工作原理
```
本地电脑                            GitHub
┌──────────┐                       ┌──────────┐
│ 私钥:    │  ◄──── 加密通信 ────► │ 公钥:    │
│id_ed25519│                       │已存公钥  │
└──────────┘                       └──────────┘
```

#### 配置步骤
1. 生成 SSH key：
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. 把公钥（`~/.ssh/id_ed25519.pub`）添加到 GitHub：
   - Settings → SSH and GPG keys → New SSH key

3. 切换远程地址为 SSH：
```bash
git remote set-url origin git@github.com:用户名/仓库名.git
```

### 4. HTTPS vs SSH 对比

| 对比项 | HTTPS + Token | SSH Key |
|--------|--------------|---------|
| 是否需要密码 | ✅ 每次或保存后 | ❌ 不需要 |
| 安全性 | 较高 | 高 |
| 配置复杂度 | 中等 | 简单 |
| 是否需要管理 token | ✅ 是 | ❌ 否 |
| 跨设备使用 | 需要重新配置 | 需要在新设备生成 key |
| 推荐场景 | 临时使用 | 长期项目（推荐） |

## 实践中的问题与解决

### 问题 1：推送失败 - 密码认证不支持

**错误信息**：
```
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed
```

**原因**：GitHub 已经停止支持密码认证

**解决**：
- 使用 Personal Access Token（PAT）代替密码
- 或者使用 SSH Key 认证

### 问题 2：推送失败 - 网络连接超时

**错误信息**：
```
Failed to connect to github.com port 443 after 21087 ms: Could not connect to server
```

**可能原因**：
- 网络限制（国内访问 GitHub）
- 防火墙阻止
- 临时网络问题

**解决方法**：
- 重试（可能就是临时的）
- 使用代理：
  ```bash
  git config --global http.proxy http://127.0.0.1:7890
  git config --global https.proxy http://127.0.0.1:7890
  ```
- 使用 SSH 443 端口绕过防火墙

### 问题 3：token 泄露怎么办？

**场景**：不小心把 token 发给了别人或 AI 助手

**立即处理**：
1. 打开 https://github.com/settings/tokens
2. 找到泄露的 token（通过 Note 识别）
3. 点击 **Delete** 删除
4. 生成新的 token 妥善保管

**预防措施**：
- 使用 SSH Key 认证（避免 token 管理）
- 使用 `gh auth login` 命令行认证（更安全）
- 永远不要把 token 粘贴到对话中

## 实战工作流

### 第一次配置项目（以本项目为例）

```bash
# 1. 克隆仓库
git clone https://github.com/X-85/ai-all-in-one.git

# 2. 切换到 SSH（推荐）
cd ai-all-in-one
git remote set-url origin git@github.com:X-85/ai-all-in-one.git

# 3. 验证 SSH 连接
ssh -T git@github.com
```

### 日常使用

```bash
# 拉取最新内容
git pull

# 查看当前状态
git status

# 添加修改
git add .

# 提交修改
git commit -m "描述信息"

# 推送到 GitHub
git push
```

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `git clone <url>` | 克隆远程仓库 |
| `git remote -v` | 查看远程地址 |
| `git remote set-url origin <url>` | 修改远程地址 |
| `git pull` | 拉取并合并远程内容 |
| `git push` | 推送到远程 |
| `git add <file>` | 添加文件到暂存区 |
| `git add .` | 添加所有修改 |
| `git commit -m "msg"` | 提交修改 |
| `git status` | 查看状态 |
| `git log` | 查看提交历史 |
| `git log --oneline` | 简洁查看历史 |
| `ssh -T git@github.com` | 测试 SSH 连接 |

## 学习心得

1. **认证方式选择**：长期项目用 SSH Key，临时使用 HTTPS + Token
2. **安全问题**：token 绝不能分享，SSH Key 的私钥也要保密
3. **遇到网络问题**：先重试，可能是临时的；再考虑代理或 SSH 443 端口
4. **配置 credential helper**：用 `git config --global credential.helper store` 可以避免每次输入密码（但只对 HTTPS 有用）

## 相关资源

- [Git 官方文档](https://git-scm.com/doc)
- [GitHub SSH 文档](https://docs.github.com/authentication/connecting-to-github-with-ssh)
- [GitHub PAT 文档](https://docs.github.com/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

---

## Git Pages 总结(精简版)

### 是什么

GitHub Pages = GitHub 提供的**免费静态网站托管**。`git push` 后站点自动更新,无需手动发布。

### 三种部署方式

| 方式 | 触发 | 适用 |
|------|------|------|
| `Deploy from a branch`(默认) | push 后自动 | 简单静态站点 |
| `gh-pages` 分支 | push 到 gh-pages | 经典方式 |
| **GitHub Actions**(本仓库用) | 自定义 workflow | 灵活,可注入构建戳、自动生成 sidebar |

### 本仓库的部署链

文件 `.github/workflows/pages.yml`:

```
push → 生成 _sidebar.md → 注入 build 戳到 index.html → 部署到 Pages
```

### 关键文件

```
.github/workflows/pages.yml  ← workflow 定义
scripts/gen_sidebar.py       ← 自动生成左侧导航
index.html                   ← docsify 入口(顶部有 build 戳)
_sidebar.md                  ← 自动生成,不要手改
```

### 浏览器看不到更新?多半是缓存

| 缓存层 | 表现 | 解决 |
|--------|------|------|
| 浏览器 | 刷新没变化 | `Cmd+Shift+R` 强制刷新 |
| Fastly CDN | 10 分钟内仍返回旧版 | 等 `max-age=600` 过期 |
| 应用缓存 | 一直旧版 | 无痕模式 / 清缓存 |

**根治**:每次部署注入 `<!-- build: <sha> @ <时间戳> -->` 到 `index.html`,内容变了缓存必失效。

### 一次完整部署耗时

- build job: 20-30 秒
- deploy job: **30 秒到 6 分钟不等**(GitHub Pages 服务端偶发延迟)
- CDN 缓存: `max-age=600`(10 分钟)
- **耐心等 5-10 分钟**再下结论

### 切换部署方式(一次性手动)

`Settings → Pages → Source`:默认 `Deploy from a branch`,推荐改成 **`GitHub Actions`**。

### 诊断命令

```bash
# 查 Pages 部署状态
curl -sS "https://api.github.com/repos/X-85/ai-all-in-one/actions/runs?per_page=3"

# 查 build 戳(确认部署到哪个 commit)
curl -sS https://x-85.github.io/ai-all-in-one/ | head -1

# 查 sidebar 内容
curl -sS https://x-85.github.io/ai-all-in-one/_sidebar.md | head
```

### 经验教训

1. **别被"页面没更新"误导** — 先用诊断命令确认 Pages 真部署了,再判断是缓存还是配置问题
2. **build 戳是最有效的 debug 信号** — 它直接告诉你 CDN serve 的是哪个 commit
3. **Pages 配置切到 GitHub Actions 是一次性操作** — 切完后所有 push 都由 workflow 自动处理