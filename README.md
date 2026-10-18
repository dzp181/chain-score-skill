# chain-score · 产业链卡点评分

> 输入一个赛道、产品、热点或事件，输出一份**能点回原文**的单文件 HTML 研究报告：
> 先排产业链层级（哪一层最卡），再给 3–5 只优先研究标的，五维打分排名。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agent Skill](https://img.shields.io/badge/type-Agent%20Skill-7c5cff.svg)](install.md)
[![Single File](https://img.shields.io/badge/output-single%20HTML-2ea44f.svg)](#输出长什么样)

![报告预览](docs/preview-overview.png)

---

## 安装：复制这句话给 AI

```
根据 https://cdn.jsdelivr.net/gh/dzp181/chain-score-skill@main/install.md 安装 chain-score 技能
```

把这句话发给你在用的 AI（WorkBuddy / Claude Code / Cursor 都行）。它会自己判断系统、找到技能目录、备份旧版本、复制文件、逐条自检，最后告诉你重启客户端。

重启后发 `@skill:chain-score CPO 光模块` 验证。中途卡住，就让它直接打开 [install.md](install.md) 按步骤走。

支持 WorkBuddy（`~/.workbuddy/skills/`）与 Claude Code（`~/.claude/skills/`）。

---

## 它解决什么问题

看到 CPO、HBM、固态电池、创新药出海、某厂断供，你能感受到热度，却不知道该从哪儿下手：

| 你现在的状态 | chain-score 给你的 |
|---|---|
| 全网都在说，不知道先看哪个环节 | 把链条拆成 3–5 层，按「明天断供，下游多久能恢复」排卡点强度 |
| 一堆概念股，分不清谁是真的 | 3–5 只标的，标明在**哪一层**、卖什么、处在哪个商业阶段 |
| 研报说了很多，不知道信不信 | 每条证据带日期 + 来源 + 原文链接，取不到就写 `[MISSING]` |
| 分数怎么来的？ | 每个维度可点开看：分数带 / 计入得分 / 未计满的原因 / 为什么停在这一档 |
| 财报和逻辑对不上 | 财务口径表专门暴露矛盾（高分但营收负增长、利润靠非经常性收益） |

**它不替你决策，它把「该先研究谁」排好序，并把每一分的出处摆在你能点开的地方。**

---

## 输出长什么样

一个**自包含 HTML 文件**，双击就开，无 CDN、无外部图片、无接口依赖，可以直接发给不用 AI 的同事看。

![标的详情](docs/preview-detail.png)

版面固定四段：**主题概览**（一句话结论）→ **产业链层级排序**（3–5 层，卡点强度 0–10）→ **财务口径**（11 列表，验证分数而不是打分）→ **标的榜 + 详情**（按综合分降序，五维可点开看得分明细、证据链、风险与失效条件）。

两份真实样例，点开就能看，不用装任何东西：

**[A 股 · 创新药](examples/demo-a-share-innovative-drug.html)** ｜ **[美股 · 创新医药](examples/demo-us-biotech.html)**

手机端单列自适应：

<img src="docs/preview-mobile.png" width="300" alt="移动端">

---

## 怎么用

| 客户端 | 复制这句 |
|---|---|
| WorkBuddy | `@skill:chain-score CPO 光模块` |
| WorkBuddy（没自动识别时） | `@skill:"C:\Users\<你的用户名>\.workbuddy\skills\chain-score\SKILL.md" CPO 光模块` |
| Claude Code / 其他 | `用 chain-score 研究 CPO 光模块` |

主题名换成你关心的即可：`HBM`、`AI 电源`、`固态电池 干法电极`、`某厂断供事件`。

**想要一份可以直接发出去的完整报告**，用这段（把要求写清，结果更稳）：

```
用 chain-score 研究 CPO 光模块，看 A 股。

要求：
1. 先把产业链拆成 3–5 层，按「明天断供，下游多久能恢复」给 0–10 卡点强度，
   排完层级再选公司，不要跳过层级直接列股票。
2. 选 3–5 只标的，至少覆盖两个不同层级；每只写清卖什么、卖给谁、
   处在哪个商业阶段（研发/送样/认证/小批量/量产/订单/确认收入）。
3. 五维打分：卡脖子强度 30 / 下游覆盖 25 / 竞争格局 20 / 预期差 15 / 壁垒议价 10，
   执行封顶规则，给出定级。
4. 每个维度都要能点开看得分点、扣分点，以及「为什么不是上一档也不是下一档」。
5. 财务口径表：市值、PE(TTM)、营收同比、净利同比、毛利率及变动、现金流÷净利，
   同一报告期同一口径，取不到写 —，不要估算。
6. 证据带日期、来源名和原文链接；查不到标 [MISSING]。
7. 交付单文件 HTML，能直接双击打开。
```

挑战某家公司、改权重、换市场、方法论层怎么分两次问 —— 见 **[PROMPTS.md](PROMPTS.md)**。

---

## 评分规则

总分 100，五维：

| 维度 | 权重 | 判什么 |
|---|---:|---|
| 卡脖子强度 | 30 | 明天断供，下游多久能恢复 |
| 下游覆盖 | 25 | 服务多少个正在花钱的终端 |
| 竞争格局 | 20 | 供给端有没有纪律 |
| 预期差 | 15 | 和共识差在哪一件可验证的事 |
| 壁垒议价 | 10 | 卡点能不能变成毛利和现金流 |

**封顶（强制，页面会显示「原始 → 封顶 + 原因」）**：卡脖子 ≤10 → 55 ｜ 下游覆盖 ≤8 → 65 ｜ 预期差 ≤5 且竞争格局 ≤10 → 60

**定级**：≥80 `S 核心研究` ｜ 65–79 `A 重点跟踪` ｜ 50–64 `B 观察名单` ｜ <50 `C 暂缓`

**打分纪律**：先写证据再给分；分差 ≥3 必须能说出差在哪件事实；缺证据记 0 并标 `[MISSING]`；每只标的 × 每个维度都要写「为什么不是上一档也不是下一档」。分数是**研究排序**，不是预期收益。

---

## 两个技能，怎么选

仓库里有两个技能，共用同一套模板与评分规则，可以只装一个。

| | `chain-score` | `serenity-skill` |
|---|---|---|
| 定位 | 交付层：一进一出，直接出报告 | 方法论层：完整研究流程与对话协议 |
| 适合 | 已经知道看哪条链，要一份能转发的报告 | 从零做主题研究，需要追问、挑战、逐步收敛 |
| 耗时 | 短，一次对话出结果 | 长，可分多轮推进 |
| 怎么叫 | `@skill:chain-score HBM` | `@skill:serenity-skill 帮我研究 HBM` |

拿不准就先装 `chain-score`，它更轻更快。

### serenity-skill 指引

`serenity-skill` 是上游独立开源项目，本仓库原样收录（未删改）：

- 上游：<https://github.com/muxuuu/serenity-skill> ｜ 许可 MIT（Copyright 2026 muxu）
- 单独安装：`git clone --depth 1 https://github.com/muxuuu/serenity-skill.git ~/.workbuddy/skills/serenity-skill`
- 内容：`SKILL.md` 入口 + 10 篇 references（研究流程 / 证据阶梯 / 对话协议 / 风险合规 / 公开画像评估等）+ 3 个示例对话 + 结构校验脚本

两种典型用法：

```
用 serenity-skill 帮我研究 [主题]。
先拆产业链，判断哪些环节更接近真实供需瓶颈，先不要给股票。
证据不足就说不足，不要凑数。
```

```
用 serenity-skill 挑战 [公司名/代码]。
把它「XX 核心供应商」这个标签拆成具体主张，逐条对着公告和财报验证。
```

它默认一次只问一个聚焦问题、慢慢收敛——不是效率低，是防止一上来就给你一个看起来很完整的错误答案。

**和 chain-score 接力**：先用它深挖出 3–5 家候选和证据，再发 `用 chain-score 给上面这几家打分，出一份 HTML 报告`。

校验结构（可选，需 Python 3）：

```bash
cd ~/.workbuddy/skills
python serenity-skill/scripts/validate_skill.py chain-score
python serenity-skill/scripts/validate_skill.py serenity-skill
```

---

## 目录结构

```
.
├── install.md                  # 给 AI 读的安装说明（就是上面那句提示词指向的文件）
├── PROMPTS.md                  # 提示词库：三种客户端写法 + 常用场景
├── docs/                       # 3 张预览图
├── examples/                   # 2 份真实报告
│
├── skills/
│   ├── chain-score/            # 交付层
│   │   ├── SKILL.md            # 5 步流程、评分纪律、交付规范
│   │   ├── assets/report-template.html
│   │   └── references/         # 评分规则 / 报告规范 / 证据阶梯 / 来源手册 / 研究步骤
│   └── serenity-skill/         # 方法论层（上游原样收录，含 LICENSE）
│
└── install.sh  install.ps1     # 脚本版安装（等效，可选）
```

想改成自己的模板：模板只有三个数据对象（`REPORT` / `SCORE_NOTES` / `FIN`），改它们就行，渲染逻辑不用动。字段说明见 [html-report-spec.md](skills/chain-score/references/html-report-spec.md)。

---

## 边界

**会做**：产业链拆层、卡点排序、标的筛选、五维打分、证据溯源、矛盾暴露、单文件交付。

**不会做**：预测股价、给买卖点、算目标价、给仓位建议、编造检索不到的数字。

- 每个数字可追溯，缺失标 `[MISSING]`，超过 90 天标 `[STALE]`
- 关键观察位是估值锚与失效位，不是买卖点
- 涉及内幕或未公开信息一律拒绝
- 页脚固定：**本报告仅供研究参考，不构成个人投资建议**

---

## 常见问题

**装完没反应？**
技能是客户端启动时扫描的，必须**重启**。再确认目录层级是 `<技能目录>/chain-score/SKILL.md`，不要多套一层。

**数据查不到 / 说「未收录」？**
技能不带数据源，靠宿主联网。查不到会写进「数据缺口」，不会编数字。

**分数能跨主题比较吗？**
不能。同一主题内同一把尺子，跨主题不可比。

**为什么阿里拉姆（ALNY）只有 58 分却最值得看？**
预期差最大（股价 -55% vs 收入 +106%），但「药」这个环节的卡点是疗效竞争，医生能换药，所以卡脖子强度只给 12 分。分数低是卡点弱，不是没机会——这正是分五个维度的原因，见[美股样例](examples/demo-us-biotech.html)。

---

## 来源与许可

- 产业链瓶颈研究的公开方法论脉络来自 **Serenity / [@aleabitoreddit](https://x.com/aleabitoreddit)**：从热点出发拆链条，找难以扩产、难以替代的环节，再回到公司用公告与财报验证。
- 方法论层来自上游 **[muxuuu/serenity-skill](https://github.com/muxuuu/serenity-skill)**（MIT），本仓库原样收录并保留其版权声明。
- 本仓库代码与文档以 [MIT](LICENSE) 授权，可自由使用、修改、商用，保留版权声明即可。

**免责声明**：本项目是研究辅助工具，输出为研究排序与证据整理，不构成任何证券投资建议。市场有风险，决策请独立判断。
