# 下载脚本 - GitHub Actions 构建产物
# 使用方法: .\download-apk.ps1 [-RunId <run_id>] [-ArtifactName <name>] [-BuildDir <dir>]

param(
    [string]$RunId = "",
    [string]$ArtifactName = "star-encounter-release",
    [string]$BuildDir = ""
)

$ErrorActionPreference = "Stop"

# 项目根目录
$ProjectRoot = Split-Path -Parent $PSScriptRoot

# 默认使用当前日期时间作为构建目录
if (-not $BuildDir) {
    $BuildDir = Get-Date -Format "yyyy-MM-dd_HHmm"
}

$BuildsDir = Join-Path $ProjectRoot "builds"
$TargetDir = Join-Path $BuildsDir $BuildDir

# 检查是否已存在
if (Test-Path $TargetDir) {
    $existingApk = Get-ChildItem -Path $TargetDir -Filter "*.apk" -ErrorAction SilentlyContinue
    if ($existingApk) {
        Write-Host "✅ APK 已存在: $($existingApk.FullName)"
        Write-Host "📁 目录: $TargetDir"
        exit 0
    }
}

# 如果没有提供 RunId，尝试获取最新的
if (-not $RunId) {
    Write-Host "🔍 正在获取最新的构建 Run ID..."
    $runs = gh run list --repo PheobeAI/star-encounter --branch main --status success -L 1 --json id
    if ($runs) {
        $RunId = $runs[0].id
        Write-Host "📋 最新 Run ID: $RunId"
    } else {
        Write-Host "❌ 无法获取构建 Run ID"
        exit 1
    }
}

# 创建目标目录
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

# 下载构建产物
Write-Host "📥 正在下载构建产物..."
Write-Host "   Run ID: $RunId"
Write-Host "   Artifact: $ArtifactName"
Write-Host "   目标目录: $TargetDir"

gh run download $RunId --repo PheobeAI/star-encounter --name $ArtifactName -D $TargetDir

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 下载完成!"
    
    # 解压 zip 文件（如果存在）
    $zipFile = Get-ChildItem -Path $TargetDir -Filter "*.zip" -ErrorAction SilentlyContinue
    if ($zipFile) {
        Write-Host "📦 正在解压..."
        Expand-Archive -Path $zipFile.FullName -DestinationPath $TargetDir -Force
        Remove-Item $zipFile.FullName -Force
    }
    
    # 显示结果
    $apkFile = Get-ChildItem -Path $TargetDir -Filter "*.apk" -ErrorAction SilentlyContinue
    if ($apkFile) {
        Write-Host ""
        Write-Host "🎉 APK 已准备就绪!"
        Write-Host "📦 文件: $($apkFile.Name)"
        Write-Host "📁 位置: $TargetDir"
        Write-Host "📊 大小: $([math]::Round($apkFile.Length / 1MB, 2)) MB"
    }
} else {
    Write-Host "❌ 下载失败"
    exit 1
}
