# 安装 chain-score 技能

> 这份说明是**写给 AI Agent 执行的**。用户把仓库地址和这句话发给你之后，按下面的顺序做完，最后把结果告诉用户。
> 目标：把 `chain-score`（可选再加 `serenity-skill`）装进本机技能目录，并让用户能立刻用上。

> **先看一眼**：如果用户就在 WorkBuddy 界面里，最省事的是让他自己导入，不用你动文件——
> 下载 `dist/chain-score.zip`（仓库里已备好，包根目录就是 `SKILL.md`），在「导入技能」里拖进去即可。
> 这种情形你回一句「已提供可直接导入的 zip，拖进导入技能即可」就行，下面的步骤跳过。

---

## 导入包符合哪些要求

`dist/*.zip` 是按 WorkBuddy「导入技能」的规则打的，已核对：

| 要求 | 落实情况 |
|---|---|
| 文件夹或 `.zip` 需包含 `SKILL.md` | `SKILL.md` 在 zip **根目录**，不套子文件夹 |
| `.md` 需含 YAML 格式的技能名称与描述 | frontmatter 含 `name: chain-score` 与完整 `description` |

改完技能内容后重新打包：`python build-zips.py`（会顺带校验 frontmatter，不合格直接报错）。

---

## 第 0 步：确认三件事

**1. 操作系统**：Windows / macOS / Linux —— 决定路径写法。

**2. 客户端类型** —— 决定目标目录：

| 客户端 | 技能目录 |
|---|---|
| WorkBuddy | `~/.workbuddy/skills/` |
| Claude Code | `~/.claude/skills/` |
| 其他 | 先问用户，或查该客户端文档，不要猜 |

`~` 的含义：Windows 是 `C:\Users\<用户名>`，macOS/Linux 是 `/Users/<用户名>` 或 `/home/<用户名>`。

**3. 目标目录里是否已存在 `chain-score` 或 `serenity-skill`**

存在就**先改名备份**成 `<技能名>.bak.<时间戳>`，再装新的。不要直接覆盖，更不要删除——用户可能改过。

不确定的信息问用户一句，不要自己假设。

---

## 第 1 步：取文件

**优先用 git**（最快、最干净）：

```bash
git clone --depth 1 https://github.com/dzp181/chain-score-skill.git <临时目录>
```

**没有 git、或 clone 超时**，改用压缩包：

- 下载：`https://codeload.github.com/dzp181/chain-score-skill/zip/refs/heads/main`
- 解压后得到目录 `chain-score-skill-main/`

两者取到的东西一样。临时目录用完可以删。

> 如果 `raw.githubusercontent.com` 拉不动（国内常见），不要卡在那里，直接用上面的 codeload 链接或 git。

---

## 第 2 步：复制到目标目录

把这两段**整个目录**复制进去：

| 来源 | 目标 |
|---|---|
| `<仓库>/skills/chain-score` | `<技能目录>/chain-score` |
| `<仓库>/skills/serenity-skill` | `<技能目录>/serenity-skill` |

- 用户只要轻量版时，只装 `chain-score` 也行，它自包含、不依赖另一个。
- 注意是复制**目录本身**，不要复制成 `chain-score/chain-score`。

---

## 第 3 步：自检（必做，别跳过）

逐条核对，全部通过再收尾：

- [ ] `<技能目录>/chain-score/SKILL.md` 存在
- [ ] `<技能目录>/chain-score/assets/report-template.html` 存在
- [ ] `<技能目录>/chain-score/references/` 下有 5 个 `.md`
- [ ] `<技能目录>/serenity-skill/SKILL.md` 存在（若装了的话）
- [ ] 打开 `chain-score/SKILL.md`，开头 frontmatter 里能看到 `name: chain-score`

数量对不上就重装，不要“大概装好了”就汇报。

---

## 第 4 步：告诉用户这四件事

按顺序说，不要长篇复述：

1. **装到哪儿了**：给出实际路径
2. **重启客户端**：技能是启动时扫描的，不重启不生效
3. **怎么验证**：发这一句
   ```
   @skill:chain-score CPO 光模块
   ```
   其他客户端把 `@skill:chain-score` 换成 `用 chain-score 研究`
4. **更多写法**：仓库里的 `PROMPTS.md`（挑战某家公司、改权重、换市场等）

验证时如果技能没被识别，常见原因是：目录多套了一层、没重启、或客户端不读这个目录——按这三条排查。

---

## 边界

- **不要**删除或覆盖用户已有的其他技能
- **不要**修改 `SKILL.md`、`references/` 里的内容（那是技能本体）
- **不要**装到用户没指定的奇怪位置
- 仓库里的 `install.sh` / `install.ps1` 是等效的脚本版，用户想用再提，默认不用
- 技能不带数据源：装好后要让 Agent 能联网检索，研究才跑得起来

装完就结束，不用顺手做别的。
