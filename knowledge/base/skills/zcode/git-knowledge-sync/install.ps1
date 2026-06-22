# 安装 git-knowledge-sync skill 到当前 Windows
# 一键安装：
#   irm https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.ps1 | iex
$ErrorActionPreference = "Stop"

$SkillName  = "git-knowledge-sync"
$RepoUrl    = "https://github.com/X-85/ai-all-in-one.git"
$Branch     = "main"
$TempDir    = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$PluginDir  = "$env:USERPROFILE\.zcode\cli\plugins\cache\zcode-plugins-official\$SkillName\0.1.0"
$DataDir    = "$env:USERPROFILE\.zcode\cli\plugins\data\${SkillName}@zcode-plugins-official"

Write-Host "📥 正在从 GitHub 拉取最新 skill..." -ForegroundColor Cyan
try {
  git clone --depth 1 --branch $Branch $RepoUrl $TempDir 2>$null | Out-Null
} catch {
  Write-Host "❌ 克隆仓库失败: $_" -ForegroundColor Red
  exit 1
}

$SkillSrc = Join-Path $TempDir "knowledge\base\skills\zcode\$SkillName"
if (-not (Test-Path $SkillSrc)) {
  Write-Host "❌ 仓库中未找到 skill: $SkillName" -ForegroundColor Red
  Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
  exit 1
}

# Windows 强制使用 SKILL.md.windows
$SkillMdSrc = Join-Path $SkillSrc "SKILL.md"
$WinSrc     = Join-Path $SkillSrc "SKILL.md.windows"
if (Test-Path $WinSrc) {
  Write-Host "✅ 检测到 Windows，使用: SKILL.md.windows" -ForegroundColor Green
  $SkillMdSrc = $WinSrc
} else {
  Write-Host "ℹ️  使用默认 SKILL.md（跨平台版）" -ForegroundColor Yellow
}

# 部署到 zcode 插件目录
Write-Host "📦 安装到 $PluginDir ..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$PluginDir\.zcode-plugin" | Out-Null
New-Item -ItemType Directory -Force -Path "$PluginDir\skills\$SkillName" | Out-Null
New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

Copy-Item $SkillMdSrc "$PluginDir\skills\$SkillName\SKILL.md" -Force

# plugin.json
$PluginJsonSrc = Join-Path $SkillSrc ".zcode-plugin\plugin.json"
$PluginJsonDst = "$PluginDir\.zcode-plugin\plugin.json"
if (Test-Path $PluginJsonSrc) {
  Copy-Item $PluginJsonSrc $PluginJsonDst -Force
} else {
  $pluginJson = @"
{
  "name": "$SkillName",
  "version": "0.1.0",
  "description": "AI 知识库的 Git 同步和提交流程（Windows 自动安装）。",
  "author": { "name": "Bruce" },
  "license": "MIT",
  "skills": "skills"
}
"@
  Set-Content -Path $PluginJsonDst -Value $pluginJson -Encoding UTF8
}

# package.json
$pkgJson = @"
{
  "name": "@bruce/$SkillName-plugin",
  "version": "0.1.0",
  "private": true,
  "license": "MIT",
  "description": "AI 知识库 Git 同步 skill（Windows 安装）。"
}
"@
Set-Content -Path "$PluginDir\package.json" -Value $pkgJson -Encoding UTF8

Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "✅ 安装完成！" -ForegroundColor Green
Write-Host "📁 插件目录: $PluginDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "👉 请重启 ZCode 使 skill 生效。" -ForegroundColor Yellow
Write-Host "   重启后可通过 /git-knowledge-sync 触发。" -ForegroundColor Yellow
