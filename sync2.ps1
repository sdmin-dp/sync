# 强制进入当前脚本所在的文件夹
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
cd $PSScriptRoot

Write-Host "==========================================" -ForegroundColor Magenta
Write-Host "       🚀 GitHub SSH 自动化同步工具" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Magenta

# 在.gitnore里面忽略此脚本
Write-Host "正在更改.gitignore文件"; Add-Content -Path ".gitignore" -Value "sync.ps1" -Encoding utf8
Add-Content -Path ".gitignore" -Value "sync2.ps1" -Encoding utf8


# 1. 强制关闭可能冲突的凭据助手，确保走 SSH
git config credential.helper ""

# 2. 同步：拉取云端最新代码
Write-Host "[1/3] 正在同步：拉取云端最新改动..." -ForegroundColor Cyan
git pull origin main --rebase

# 3. 打包：扫描并提交本地所有修改
Write-Host "[2/3] 正在打包：扫描本地代码变动..." -ForegroundColor Green
git add .
$currentDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
git commit -m "Auto Sync: $currentDate"

# 4. 上传：通过 SSH 密匙安全推送到 GitHub
Write-Host "[3/3] 正在上传：安全推送至 GitHub 云端..." -ForegroundColor Yellow
git push -u origin main

Write-Host "==========================================" -ForegroundColor Magenta
Write-Host "🎉 恭喜！云端与本地已完全合一！" -ForegroundColor Green
Write-Host "按任意键退出..." -ForegroundColor Cyan
[void][System.Console]::ReadKey($true)
