# chain-score 技能包安装脚本 (Windows)
#
# 默认安装两个技能:
#   chain-score     交付层：排层级 + 五维评分 + 出报告
#   serenity-skill  方法论层：完整产业链研究流程
#
# 用法:
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Target "$env:USERPROFILE\.claude\skills"
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Only chain-score

param(
    [string]$Target = "$env:USERPROFILE\.workbuddy\skills",
    [string]$Only = ""
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Skills = @("chain-score", "serenity-skill")
if ($Only -ne "") {
    $Skills = @($Only)
}

if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

foreach ($s in $Skills) {
    $Src = Join-Path $Root "skills\$s"
    if (-not (Test-Path (Join-Path $Src "SKILL.md"))) {
        Write-Output "失败: 找不到 $Src\SKILL.md"
        Write-Output "请在仓库根目录运行本脚本。"
        exit 1
    }

    $Dest = Join-Path $Target $s
    if (Test-Path $Dest) {
        $Bak = "$Dest.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item $Dest $Bak
        Write-Output "· $s 旧版本已备份到 $Bak"
    }

    Copy-Item $Src $Dest -Recurse
    Write-Output "✓ $s → $Dest"
}

Write-Output ""
Write-Output "文件清单:"
foreach ($s in $Skills) {
    $Dest = Join-Path $Target $s
    Push-Location $Dest
    $base = (Get-Location).Path.Length + 1
    Get-ChildItem -Recurse -File | ForEach-Object {
        Write-Output ("  $s/" + $_.FullName.Substring($base).Replace('\', '/'))
    }
    Pop-Location
}

Write-Output ""
Write-Output "下一步: 重启客户端，然后发一句「用 chain-score 研究 HBM」验证。"
