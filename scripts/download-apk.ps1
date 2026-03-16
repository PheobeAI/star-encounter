@echo off
REM ============================================
REM Star Encounter - APK 下载脚本
REM ============================================

$ErrorActionPreference = "Stop"

# 配置
$repo = "PheobeAI/star-encounter"
$buildDir = "C:\Users\Pheobe\.openclaw\workspaces\WS_Pheobe\builds\star-encounter"
$versionDir = "$buildDir\$((Get-Date).ToString('yyyy-MM-dd'))"

# 创建构建目录
if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
    Write-Host "创建构建目录: $buildDir"
}

# 创建版本目录
if (-not (Test-Path $versionDir)) {
    New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
    Write-Host "创建版本目录: $versionDir"
}

# 获取最新的成功构建
Write-Host "正在查找最新的成功构建..."
$runId = gh run list --repo $repo --workflow build-android.yml --limit 1 --json databaseId,status --jq '.[0].databaseId'
$status = gh run view $runId --repo $repo --json status --jq '.status'

if ($status -ne "success") {
    Write-Host "错误: 最新构建未成功完成" -ForegroundColor Red
    exit 1
}

Write-Host "找到构建 ID: $runId" -ForegroundColor Green

# 下载 APK
Write-Host "正在下载 APK 文件..."
gh run download $runId --repo $repo --name star-encounter-release --dir $versionDir

if ($LASTEXITCODE -eq 0) {
    Write-Host "下载成功！" -ForegroundColor Green
    Write-Host "APK 位置: $versionDir\app-release.apk"
} else {
    Write-Host "下载失败" -ForegroundColor Red
    exit 1
}
