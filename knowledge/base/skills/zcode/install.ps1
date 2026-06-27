# zcode skills 一键安装脚本（Windows PowerShell）
# 自动从 GitHub 拉取最新 skill，遍历 zcode/ 下所有 skill 目录，
# 按 .scope 文件（project / user）决定安装位置。
#
# 一键安装：
#   irm https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/install.ps1 | iex
#
# 环境变量：
#   ZCODE_PROJECT_ROOT  强制指定项目根（默认用 git rev-parse 自动定位）
#   ZCODE_DRY_RUN=1     只打印不实际写入

$ErrorActionPreference = "Stop"

# 定位自身目录
if ($PSCommandPath) {
    $ScriptDir = Split-Path -Parent $PSCommandPath
} else {
    # irm | iex 场景：从临时目录反查
    $ScriptDir = $PSScriptRoot
}
$RepoUrl        = "https://github.com/X-85/ai-all-in-one.git"
$Branch         = "main"
$PluginVersion  = "0.1.0"
$DryRun         = if ($env:ZCODE_DRY_RUN -eq "1") { $true } else { $false }

# 1. 优先从 GitHub 拉取最新 skill；失败则用本地
$TempDir = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
Write-Host "📥 正在从 GitHub 拉取最新 skill..." -ForegroundColor Cyan
try {
    git clone --depth 1 --branch $Branch $RepoUrl $TempDir 2>$null | Out-Null
    $SkillsRoot = Join-Path $TempDir "knowledge\base\skills\zcode"
    Write-Host "✅ 已从 GitHub 拉取" -ForegroundColor Green
} catch {
    Write-Host "⚠️  GitHub 拉取失败，使用本地 skill" -ForegroundColor Yellow
    $SkillsRoot = $ScriptDir
}

# 2. 定位项目根（用于 project scope）
if ($env:ZCODE_PROJECT_ROOT) {
    $ProjectRoot = $env:ZCODE_PROJECT_ROOT
} else {
    try {
        $ProjectRoot = (& git rev-parse --show-toplevel 2>$null) | Out-String
        $ProjectRoot = $ProjectRoot.Trim()
        if ([string]::IsNullOrEmpty($ProjectRoot)) { $ProjectRoot = $null }
    } catch {
        $ProjectRoot = $null
    }
}

# 3. 遍历每个 skill 目录
$Installed = 0
$Skipped   = 0
Get-ChildItem -Path $SkillsRoot -Directory | ForEach-Object {
    $skill_dir = $_.FullName
    $skill_name = $_.Name
    $skill_md = Join-Path $skill_dir "SKILL.md"
    if (-not (Test-Path $skill_md)) { return }

    # 读 .scope
    $scope_file = Join-Path $skill_dir ".scope"
    if (Test-Path $scope_file) {
        $scope = (Get-Content $scope_file -Raw).Trim()
    } else {
        $scope = "user"
    }

    switch ($scope) {
        "project" {
            if (-not $ProjectRoot) {
                Write-Host "  ⚠️  $skill_name : scope=project 但不在 git 仓库中（设 `$env:ZCODE_PROJECT_ROOT 覆盖），跳过" -ForegroundColor Yellow
                $script:Skipped++
                return
            }
            $target = Join-Path $ProjectRoot ".agents\skills\$skill_name"
            if ($DryRun) {
                Write-Host "  🔍 $skill_name → [project] $target\SKILL.md (dry-run)" -ForegroundColor Cyan
            } else {
                New-Item -ItemType Directory -Force -Path $target | Out-Null
                Copy-Item $skill_md "$target\SKILL.md" -Force
                Write-Host "  ✅ $skill_name → [project] $target" -ForegroundColor Green
            }
            $script:Installed++
        }
        "user" {
            $target = "$env:USERPROFILE\.zcode\cli\plugins\cache\zcode-plugins-official\$skill_name\$PluginVersion\skills\$skill_name"
            if ($DryRun) {
                Write-Host "  🔍 $skill_name → [user] $target\SKILL.md (dry-run)" -ForegroundColor Cyan
            } else {
                New-Item -ItemType Directory -Force -Path $target | Out-Null
                Copy-Item $skill_md "$target\SKILL.md" -Force
                Write-Host "  ✅ $skill_name → [user] $target" -ForegroundColor Green
            }
            $script:Installed++
        }
        default {
            Write-Host "  ❌ $skill_name : 未知 scope '$scope'，跳过" -ForegroundColor Red
            $script:Skipped++
        }
    }
}

# 4. 清理临时目录
if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "✅ 共安装 $Installed 个 skill（跳过 $Skipped 个）" -ForegroundColor Green
Write-Host "👉 请重启 zcode 使新 skill 生效" -ForegroundColor Yellow
Write-Host "   在 zcode 中输入 /<skill-name> 即可触发" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
