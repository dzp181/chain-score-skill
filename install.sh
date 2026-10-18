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

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.workbuddy/skills"
ONLY=""

while [ $# -gt 0 ]; do
  case "$1" in
    --only)
      ONLY="${2:-}"
      shift 2
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

echo ""
echo "下一步: 重启客户端，然后发一句「用 chain-score 研究 HBM」验证。"
