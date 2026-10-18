---
name: serenity-skill
description: Research technology and advanced-manufacturing supply-chain bottlenecks (Serenity method) and deliver a single-file HTML report. Trigger when the user enters a track, product, hotspot or event and wants to know which A-share chain companies to study first. Scores every candidate on a fixed 100-point rubric (bottleneck severity 30, downstream coverage 25, competitive structure 20, expectation gap 15, pricing power 10), ranks them with a financial snapshot table (market cap, PE, revenue/profit growth, gross margin, cash-flow quality), and outputs an interactive Apple liquid-glass HTML dashboard. Also covers company thesis challenges, candidate comparisons, and learning the method.
license: MIT
compatibility: Requires a host agent with web search or access to current filings for live research. Output is a self-contained HTML file.
metadata:
  author: muxu
  version: "1.3.0"
  short-description: Supply-chain bottleneck research delivered as a scored HTML dashboard
---

# Serenity.skill

从一条技术/产业建设线索出发，追到系统里**最难扩容的输入**，再判断哪些公司能把这个约束变成利润。研究过程沿用 Serenity 路径，**交付物固定为单文件 HTML 报告**：输入一个赛道/产品/热点/事件，输出一条产业链、一批候选标的、一套五维分数和下一步该查什么。

> 本技能是对公开研究材料的独立解读，非 Serenity 官方产品。方法出处见 [公开资料说明](references/public-profile-and-evaluation.md)。

## 一、输入

用户给一句话即可：赛道（CPO 光模块）、产品（HBM、干法电极）、热点（AI 电源）、事件（某厂断供/某标准发布）。

缺信息时按默认推进，不要卡住：
- 市场未指定 → 默认 A 股科技与先进制造
- 主题过宽（如"AI"）→ 自动收窄到最有卡点的 2–3 个子环节，并在报告里说明收窄理由
- 用户给了评分规则 → 覆盖默认 rubric，权重必须加总为 100

## 二、研究流程

按顺序走，不要跳步。细节见 [研究流程](references/deep-research-workflow.md) 与 [证据阶梯](references/evidence-ladder.md)。

1. **系统变化**：什么需求或技术变化制造了压力，真正的物理/经济约束是什么
2. **产业链层级**：把链条拆成 3–5 层（上游/中游/下游），逐层判断"断供后下游多久能恢复"，给出 0–10 的卡点强度并排序。**这一步的结论必须先于选股出现**
3. **公司暴露**：在卡点层级里找 3–5 家，说明它实际卖什么、卖给谁、处在哪个商业阶段。研发 / 送样 / 认证 / 小批量 / 量产 / 订单 / 确认收入，必须分清
4. **利润捕获**：这块业务有多大，需求能否变成收入、毛利、现金流和股东利润
5. **估值与时点**：当前价格已经反映什么，用带日期的行情与明确的盈利周期
6. **反方**：什么证据会让这个优先级掉下来

先讲清层级优先级，再排公司优先级；两边都要在证据出现矛盾时更新。上游、冷门、非共识本身都不构成加分理由。层级很卡但公司不卡，是最常见的误判，必须在报告里写明"卡在这一层，但这家公司不在卡点的关键位置"。

## 三、五维评分（核心）

完整判定标准、分数带、反作弊规则见 [五维卡点评分规则](references/scoring-rubric.md)。执行要点：

| 维度 | 权重 | 判什么 |
|---|---:|---|
| 卡脖子强度 | 30 | 明天断供，下游多久能恢复 |
| 下游覆盖 | 25 | 服务多少个正在花钱的终端 |
| 竞争格局 | 20 | 供给端有没有纪律 |
| 预期差 | 15 | 和共识差在哪一件可验证的事 |
| 壁垒议价 | 10 | 卡点能不能变成毛利和现金流 |

**打分纪律**
1. 先写证据再给分，禁止先定分数再找理由
2. 同一主题内必须同一把尺子；分差 ≥3 必须能说出差在哪件事实
3. 跨主题分数不可直接比较
4. 缺证据记 0 并标 `[MISSING]`，不代为估算
5. 封顶规则必须执行并在报告里显示"原始 → 封顶 + 原因"：
   - 卡脖子强度 ≤10 → 总分封顶 55
   - 下游覆盖 ≤8 → 封顶 65
   - 预期差 ≤5 且竞争格局 ≤10 → 封顶 60
6. 定级：≥80 **S 核心研究** / 65–79 **A 重点跟踪** / 50–64 **B 观察名单** / <50 **C 暂缓**

分数是**研究排序**，不是预期收益，不是买入信号。报告里必须出现这句话。

## 四、输出：单文件 HTML

格式硬约束、版面结构、数据模型、交互与视觉规范见 [HTML 报告输出规范](references/html-report-spec.md)。

**动作**：复制 [报告模板](assets/report-template.html)，只替换三个对象 `const REPORT = {...}`、`const SCORE_NOTES = {...}`、`const FIN = {...}`，其余不动。

**版面顺序固定**
1. 主题概览：名称、一句话结论、标的数 / A 级以上 / 最高分；右上角是「示例徽标 + 复制结论 + 研究日」
2. **产业链层级排序**：3–5 层，卡点强度 0–10，标注优先研究 / 跟踪 / 观察 / 不优先
3. **优先研究标的财务口径**：11 列表格（标的 / 层级 / 综合分 / 收盘价 / 市值(亿) / PE(TTM) / 营收 YoY / 净利 YoY / 毛利率 / 毛利率变动 / 现金流÷净利），按综合分排序，窄屏容器内横向滚动
4. 主区左右分栏：**左=优先研究标的（3–5 只，按综合分从高到低）**，**右=选中标的详情**（分数环+定级、五维、核心洞察、产业链位置、排序理由、证据链、主要风险、失效条件、关键观察位、数据缺口）

必须做到：
- 单文件自包含，`file://` 双击可用，无外部 CDN / 图片 / 接口
- 层级结论在公司结论之前出现，不允许跳过层级直接列股票
- 财务口径排在层级之后、标的列表之前：它是**验证**不是打分，分数高但营收负增长、净利靠非经常性收益、毛利率下滑却给高分，这些矛盾必须解释或降分，不许两张表各说各话
- 左列表按封顶后总分降序；点选后右侧详情与分数环同步
- **五个维度卡片可点击展开得分明细**（分数带 / 计入得分 / 未计满 / 判定依据 / 为什么停在这一档），数据写在 `SCORE_NOTES`，必须覆盖 N 只 × 5 维
- **不设搜索框**：报告是单次运行的静态快照，页内检索无处可查，切换主题用主题概览的 chips
- 苹果液态玻璃：`backdrop-filter: blur(26px) saturate(200%)` + 双层高光描边 + 22px 大圆角 + 环境光渐变背景
- 降级齐全：`prefers-reduced-motion` / `prefers-reduced-transparency` / `prefers-color-scheme: dark` / `prefers-contrast`
- 证据每条带发布日期与来源，并尽量补 `url`（渲染为可点击 `↗`）与 `page`（页码/问答编号）；页脚固定"本报告仅供研究参考，不构成个人投资建议"
- 生成的报告 `meta.demo = false`，演示数值必须清空重填，`meta.finPeriod` 与 `meta.priceDate` 必须填

交付时告诉用户：文件在哪里、层级卡在哪、先研究谁、最大的未解问题是什么。

## 五、其他任务形态

- **公司质疑**：把一个标签（如"CPO 核心供应商"）拆成具体主张，逐条对当期披露验证，再打分
- **候选对比**：同一报告周期内横向对比，给出层级差异与分差来源
- **方法学习**：按 [对话协议](references/serenity-dialogue-protocol.md) 一次问一个关键问题，不套模板

## 六、边界

- 每个数字可追溯，否则标 `[MISSING]`；超过 90 天的数据标 `[STALE]`
- 检索不到 ≠ 不存在，报告中要区分"已查来源未见"与"不存在"
- 《关键观察位》写的是估值锚与失效位，不是买卖点，不提供仓位建议
- 涉及内幕信息一律拒绝

## 参考

- [A 股 AI 半导体扫描示例](examples/a-share-ai-semiconductor-demo.md)
- [CPO 公司质疑示例](examples/cpo-company-challenge.md)
- [学习对话示例](examples/demo-conversation.md)
- [提问模板包](assets/research-prompt-pack.md)
