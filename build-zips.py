#!/usr/bin/env python3
"""把 skills/ 下的技能打成 WorkBuddy「导入技能」能直接吃的 zip。

规则（对应 WorkBuddy 导入弹窗的要求）：
  - zip 里必须能找到 SKILL.md
  - SKILL.md 开头必须是 YAML frontmatter，且含 name 与 description

产物：SKILL.md 直接放在 zip 根目录，不解到子文件夹里——
这样 zip 本身就等价于"一个含 SKILL.md 的文件夹"，导入器无论按根目录找
还是递归找都能命中。

  dist/chain-score.zip       -> SKILL.md / assets/ / references/
  dist/serenity-skill.zip    -> SKILL.md / assets/ / references/ / ...

用法：python build-zips.py
"""

import os
import re
import sys
import zipfile

ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, "skills")
DIST = os.path.join(ROOT, "dist")
SKILLS = ["chain-score", "serenity-skill"]

SKIP_DIRS = {"__pycache__", ".git", "node_modules", ".idea", ".vscode"}
SKIP_FILES = {".DS_Store", "Thumbs.db", "desktop.ini"}


def check_frontmatter(skill_md_path):
    """返回 (name, description)；不符合要求就抛错。"""
    with open(skill_md_path, encoding="utf-8") as f:
        text = f.read()
    if not text.startswith("---"):
        raise ValueError("SKILL.md 没有以 --- 开头，缺少 YAML frontmatter")
    end = text.find("\n---", 3)
    if end == -1:
        raise ValueError("SKILL.md 的 YAML frontmatter 没有闭合的 ---")
    fm = text[3:end]

    def field(key):
        m = re.search(r"^%s:\s*(.+)$" % key, fm, re.M)
        return m.group(1).strip() if m else ""

    name, desc = field("name"), field("description")
    if not name:
        raise ValueError("frontmatter 缺 name")
    if not desc:
        raise ValueError("frontmatter 缺 description")
    return name, desc


def build(skill):
    src_dir = os.path.join(SRC, skill)
    skill_md = os.path.join(src_dir, "SKILL.md")
    if not os.path.isfile(skill_md):
        raise FileNotFoundError("找不到 %s" % skill_md)

    name, desc = check_frontmatter(skill_md)
    if name != skill:
        raise ValueError("%s 的 frontmatter name=%r 与目录名不一致" % (skill, name))

    os.makedirs(DIST, exist_ok=True)
    out = os.path.join(DIST, "%s.zip" % skill)
    count = 0
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for root, dirs, files in os.walk(src_dir):
            dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS)
            for fn in sorted(files):
                if fn in SKIP_FILES or fn.endswith(".pyc") or fn.startswith("._"):
                    continue
                full = os.path.join(root, fn)
                rel = os.path.relpath(full, src_dir).replace(os.sep, "/")
                z.write(full, rel)
                count += 1
    size = os.path.getsize(out) / 1024
    print("  %-16s %2d 个文件  %6.1f KB  name=%s" % (skill, count, size, name))
    print("    description: %s..." % desc[:46])
    return out


def main():
    print("打包技能 -> dist/")
    for s in SKILLS:
        build(s)
    print("完成。")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("失败: %s" % e)
        sys.exit(1)
