# 多设备 GitHub 同步方案

> 本文档记录如何通过 GitHub 实现 Mac 和 Windows 两台电脑之间的知识库同步

## 背景

- **需求**：在 Windows 台式机和 Mac 笔记本之间同步维护同一个 AI 知识库
- **方案**：使用 GitHub 作为中间桥梁，通过 Git 命令进行同步
- **额外**：使用 docsify + GitHub Pages 把知识库变成可在线访问的文档网站

## 仓库信息

- **仓库地址**：https://github.com/X-85/ai-all-in-one
- **本地路径**（Windows）：`D:\personal\XProject\ai-all-in-one`
- **本地路径**（Mac）：待同步设置

## 完整流程记录

### 1. Mac 端：初始化仓库并推送

在 Mac 电脑上：
```bash
# 进入知识库目录
cd ~/path/to/ai-all-in-one

# 初始化 Git 仓库
git init

# 添加远程仓库
git remote add origin https://github.com/X-85/ai-all-in-one.git

# 添加所有文件
git add .

# 提交
git commit -m "初始化知识库"

# 推送到 GitHub
git push -u origin main
```

### 2. Windows 端：克隆仓库

在 Windows 电脑上：
```bash
# 克隆仓库
git clone https://github.com/X-85/ai-all-in-one.git

# 移动到目标目录（D盘）
mv ai-all-in-one D:\personal\XProject\
```

### 3. Windows 端：配置 docsify

创建 `index.html`、`_sidebar.md`、`README.md`、`.nojekyll` 等配置文件。

```bash
git add .
git commit -m "feat: 添加 docsify 文档网站配置"
git push origin main
```

### 4. GitHub 端：启用 GitHub Pages

1. 打开仓库 Settings → Pages
2. Source 选择 **Deploy from a branch**
3. Branch 选择 **main** 和 **/ (root)**
4. 点击 **Save**
5. 等待 1-2 分钟

**注意**：如果仓库是 Private 状态，需要先改为 Public 才能使用 GitHub Pages。

### 5. 访问网站

网站地址：
```
https://x-85.github.io/ai-all-in-one/
```

## 日常使用流程

### 在 Mac 上更新知识库

```bash
# 拉取最新内容
git pull

# 编辑文档...

# 提交并推送
git add .
git commit -m "更新内容描述"
git push
```

### 在 Windows 上同步

```bash
cd D:\personal\XProject\ai-all-in-one

# 拉取最新内容
git pull
```

## 关键知识点

### Git 同步的优势

- ✅ 自动同步两台电脑的内容
- ✅ 完整的版本控制历史
- ✅ 改错了可以回滚
- ✅ 不会丢失数据（GitHub 永久保存）

### ZCode 同步说明

ZCode（AI 代码助手）是本地工具，**不支持跨设备同步**。Mac 和 Windows 上的对话上下文是独立的。如果需要保持对话一致性：

- 使用 **Session ID** 跨设备继续对话
- 或者直接开始新的对话（因为 ZCode 是辅助工具，不需要同步）

### GitHub Pages 注意事项

- 仓库需要是 **Public** 才能使用免费 Pages
- 私有仓库需要 **GitHub Enterprise** 才能用 Pages
- Pages 部署需要 1-2 分钟

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `git clone <url>` | 克隆远程仓库 |
| `git pull` | 拉取最新内容 |
| `git add .` | 添加所有修改 |
| `git commit -m "消息"` | 提交修改 |
| `git push` | 推送到远程 |
| `git status` | 查看当前状态 |
| `git log` | 查看提交历史 |

## 故障排查

### 推送失败：权限问题

需要配置 GitHub 认证：
- HTTPS：使用 Personal Access Token (PAT)
- SSH：配置 SSH Key

### 克隆失败：网络问题

可以尝试：
- 使用代理
- 使用 SSH 协议代替 HTTPS

### GitHub Pages 不显示

检查：
1. 仓库是否为 Public
2. Pages 设置是否正确（main 分支 + root 目录）
3. 等待 2-3 分钟后再访问

## 相关资源

- [Git 官方文档](https://git-scm.com/doc)
- [GitHub Pages 文档](https://docs.github.com/pages)
- [docsify 官方文档](https://docsify.js.org/)