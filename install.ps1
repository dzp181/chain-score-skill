# chain-score 安装脚本 (Windows)
# 用法:
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Target "$env:USERPROFILE\.claude\skills"

param(
    [string]$Target = "$env:USERPROFILE\.workbuddy\skills"
)

$ErrorActionPreference = "Stop"

$Src = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "skills\chain-score"

if (-not (Test-Path (Join-Path $Src "SKILL.md"))) {
    Write-Output "失败: 找不到 $Src\SKILL.md"
    Write-Output "请在仓库根目录运行本脚本。"
    exit 1
}

if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

$Dest = Join-Path $Target "chain-score"

if (Test-Path $Dest) {
    $Bak = "$Dest.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Move-Item $Dest $Bak
    Write-Output "已有版本已备份到 $Bak"
}

Copy-Item $Src $Dest -Recurse

$DestPath = (Resolve-Path $Dest).Path

Write-Output ""
Write-Output "安装完成: $DestPath"
Write-Output ""
Write-Output "文件清单:"

Push-Location $DestPath
$base = (Get-Location).Path.Length + 1
Get-ChildItem -Recurse -File | ForEach-Object {
    Write-Output ("  " + $_.FullName.Substring($base))
}
Pop-Location

Write-Output ""
Write-Output "下一步: 重启客户端，然后发一句「用 chain-score 研究 HBM」验证。"
