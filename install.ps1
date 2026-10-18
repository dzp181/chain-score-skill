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
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Copy

param(
    [string]$Target = "$env:USERPROFILE\.workbuddy\skills",
    [string]$Only = "",
    [switch]$Copy
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

# ---------- 提示词 ----------
$PromptCS = @'
@skill:chain-score CPO 光模块
请先排产业链层级（卡点强度 0-10，先定层级再选公司），再给 3-5 只优先研究标的，
按五维评分从高到低排序：卡脖子强度 30 / 下游覆盖 25 / 竞争格局 20 / 预期差 15 / 壁垒议价 10。
每个维度的得分点、扣分点、为什么停在这一档都要能点开看；
证据带日期、来源名和原文链接，查不到标 [MISSING] 不要估算；
财务口径用同一报告期同一口径，取不到写 —。
最后交付单文件 HTML。
'@

$PromptSer = @'
用 serenity-skill 帮我研究 [主题]。
先拆产业链，判断哪些环节更接近真实供需瓶颈，先不要给股票。
证据不足就说不足，不要凑数。
'@

if (($Skills.Count -gt 1) -or ($Skills[0] -eq "chain-score")) {
    $Prompt = $PromptCS
    $Main = "chain-score"
} else {
    $Prompt = $PromptSer
    $Main = "serenity-skill"
}

Write-Output ""
Write-Output "============================================================"
Write-Output " 装好了。复制下面这段到 WorkBuddy 就能跑："
Write-Output "============================================================"
Write-Output ""
Write-Output $Prompt
Write-Output ""
Write-Output "------------------------------------------------------------"
if ($Main -eq "chain-score") {
    Write-Output " Claude Code / 其他客户端：把开头换成「用 chain-score 研究」，其余照抄。"
    Write-Output " 挑战某家公司、改权重、换市场等写法见 PROMPTS.md"
} else {
    Write-Output " 这是方法论层的入口。拿到结论后要出评分报告，再发一句："
    Write-Output " 「用 chain-score 给上面这几家打分并出一份 HTML 报告」"
    Write-Output " 更多写法见 PROMPTS.md"
}
Write-Output "============================================================"

if ($Copy) {
    try {
        Set-Clipboard -Value $Prompt
        Write-Output "已复制到剪贴板，直接粘贴即可。"
    } catch {
        Write-Output "复制到剪贴板失败，请手动复制上面的提示词。"
    }
}

Write-Output ""
Write-Output "下一步: 重启客户端，让技能被扫描到。"
