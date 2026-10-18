#!/usr/bin/env bash
# chain-score 安装脚本 (macOS / Linux)
# 用法:
#   bash install.sh                      # 装到 ~/.workbuddy/skills
#   bash install.sh ~/.claude/skills     # 装到 Claude Code
#   bash install.sh /path/to/skills      # 自定义目录

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SRC_DIR/skills/chain-score"
TARGET="${1:-$HOME/.workbuddy/skills}"

if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
  echo "✗ 找不到 $SKILL_SRC/SKILL.md"
  echo "  请在仓库根目录运行本脚本。"
  exit 1
fi

mkdir -p "$TARGET"

if [ -d "$TARGET/chain-score" ]; then
  BAK="$TARGET/chain-score.bak.$(date +%Y%m%d%H%M%S)"
  mv "$TARGET/chain-score" "$BAK"
  echo "· 已有版本已备份到 $BAK"
fi

cp -R "$SKILL_SRC" "$TARGET/chain-score"

echo "✓ 已安装到 $TARGET/chain-score"
echo ""
echo "文件清单:"
find "$TARGET/chain-score" -type f | sed "s|$TARGET/chain-score/|  |"
echo ""
echo "下一步: 重启客户端，然后发一句「用 chain-score 研究 HBM」验证。"
