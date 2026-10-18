#!/usr/bin/env bash
# chain-score 技能包安装脚本 (macOS / Linux)
#
# 默认安装两个技能:
#   chain-score     交付层：排层级 + 五维评分 + 出报告
#   serenity-skill  方法论层：完整产业链研究流程
#
# 用法:
#   bash install.sh                        # 装到 ~/.workbuddy/skills
#   bash install.sh ~/.claude/skills       # 装到 Claude Code
#   bash install.sh --only chain-score     # 只装一个
#   bash install.sh --copy                 # 装完并把提示词复制到剪贴板

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.workbuddy/skills"
ONLY=""
DO_COPY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --only)
      ONLY="${2:-}"
      shift 2
      ;;
    --copy)
      DO_COPY=1
      shift
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

SKILLS=("chain-score" "serenity-skill")
if [ -n "$ONLY" ]; then
  SKILLS=("$ONLY")
fi

mkdir -p "$TARGET"

for s in "${SKILLS[@]}"; do
  SRC="$SRC_DIR/skills/$s"
  if [ ! -f "$SRC/SKILL.md" ]; then
    echo "失败: 找不到 $SRC/SKILL.md"
    echo "请在仓库根目录运行本脚本。"
    exit 1
  fi

  if [ -d "$TARGET/$s" ]; then
    BAK="$TARGET/$s.bak.$(date +%Y%m%d%H%M%S)"
    mv "$TARGET/$s" "$BAK"
    echo "· $s 旧版本已备份到 $BAK"
  fi

  cp -R "$SRC" "$TARGET/$s"
  echo "✓ $s → $TARGET/$s"
done

echo ""
echo "文件清单:"
for s in "${SKILLS[@]}"; do
  find "$TARGET/$s" -type f | sed "s|$TARGET/$s/|  $s/|"
done

# ---------- 提示词 ----------
PROMPT_CS='@skill:chain-score CPO 光模块
请先排产业链层级（卡点强度 0-10，先定层级再选公司），再给 3-5 只优先研究标的，
按五维评分从高到低排序：卡脖子强度 30 / 下游覆盖 25 / 竞争格局 20 / 预期差 15 / 壁垒议价 10。
每个维度的得分点、扣分点、为什么停在这一档都要能点开看；
证据带日期、来源名和原文链接，查不到标 [MISSING] 不要估算；
财务口径用同一报告期同一口径，取不到写 —。
最后交付单文件 HTML。'

PROMPT_SER='用 serenity-skill 帮我研究 [主题]。
先拆产业链，判断哪些环节更接近真实供需瓶颈，先不要给股票。
证据不足就说不足，不要凑数。'

if [ ${#SKILLS[@]} -gt 1 ] || [ "${SKILLS[0]}" = "chain-score" ]; then
  PROMPT="$PROMPT_CS"
  MAIN="chain-score"
else
  PROMPT="$PROMPT_SER"
  MAIN="serenity-skill"
fi

echo ""
echo "============================================================"
echo " 装好了。复制下面这段到 WorkBuddy 就能跑："
echo "============================================================"
echo ""
printf '%s\n' "$PROMPT"
echo ""
echo "------------------------------------------------------------"
if [ "$MAIN" = "chain-score" ]; then
  echo " Claude Code / 其他客户端：把开头换成「用 chain-score 研究」，其余照抄。"
  echo " 挑战某家公司、改权重、换市场等写法见 PROMPTS.md"
else
  echo " 这是方法论层的入口。拿到结论后要我出评分报告，再发一句："
  echo " 「用 chain-score 给上面这几家打分并出一份 HTML 报告」"
  echo " 更多写法见 PROMPTS.md"
fi
echo "============================================================"

# ---------- 复制到剪贴板 ----------
if [ "$DO_COPY" = "1" ]; then
  if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$PROMPT" | pbcopy && echo "已复制到剪贴板（pbcopy），直接粘贴即可。"
  elif command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$PROMPT" | wl-copy && echo "已复制到剪贴板（wl-copy），直接粘贴即可。"
  elif command -v xclip >/dev/null 2>&1; then
    printf '%s' "$PROMPT" | xclip -selection clipboard && echo "已复制到剪贴板（xclip），直接粘贴即可。"
  elif command -v xsel >/dev/null 2>&1; then
    printf '%s' "$PROMPT" | xsel --clipboard --input && echo "已复制到剪贴板（xsel），直接粘贴即可。"
  else
    echo "未找到剪贴板工具，请手动复制上面的提示词。"
  fi
fi

echo ""
echo "下一步: 重启客户端，让技能被扫描到。"
