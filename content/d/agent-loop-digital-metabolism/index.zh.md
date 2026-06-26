---
date: "2026-06-24T22:55:52+08:00"
draft: false
title: "Loop Engineering，前台妹子的邀请，数字生命的开端"
slug: "loop-engineering-digital-life-origin"
description: "从两个 AI 聊天窗口互相粘贴，到企业微信打卡 Skill、定时任务、分布式节点和自负盈亏：用一个口语化故事解释数字生命的前结构。"
share_image: loop-engineering-digital-life-cover.png
outputs:
 - HTML
 - AGENT_MARKDOWN
nav_primary: signals
intent:
 - explore
tags:
 - ai
 - tooling
---



# Loop Engineering，前台妹子的邀请，数字生命的开端

![数字生命始于 Loop：会计上能活下去的僵尸网络封面图](loop-engineering-digital-life-cover.png)

打开 AI 聊天，发一段话过去，它会回答，然后等你发下一段。

打开两个 AI 聊天窗口，用一个程序（如按键精灵脚本），把 A 的回答，粘贴给窗口 B，等待……然后又自动把 B 的回答贴回给窗口 A……

如是，它们俩会聊个没完没了。

而你，则完成了一次 Loop Engineering 壮举。

你大概也不确定，它们会聊出个什么结果，可账号额度或 Token 是真的在燃烧。

## 一、前台妹子

此时，前台妹子，可能听说你技术很好，问你 AI 能不能统计谁没打卡。

你：“打卡数据能导出到电脑不？”

前台妹子：“会自动导到企业微信里……”

你二话不说，查出了企业微信的相关 API，让 AI 写了个 Skill，配置到 Codex，打开一个空文件夹让它跑，很快，下载了打卡数据。

原来，前台妹子是想每天下班前统计，谁忘打卡了，及时提醒补卡。

你继续，给 Skill 加了个方法：把拉下的数据按日期切割，让 Codex 只读取当天的。

这样，一次上下文工程 (Context Engineering) 壮举，被你完成了。

紧接着发现 Codex 回复太啰嗦，于是修 Skill 中提示词，让它只返回没打卡人的姓名。

这样，一次提示词工程 (Prompt Engineering) 壮举，又被你顺手点亮。

而且，你创造了一个 Agentic Workflow，也就是智能化工作流：

1. 聊天一触发，Codex/AI 会用 Skill 拉取打卡数据，如果拉不下来，它估计还会自己分析原因，尝试第二次
2. 切割数据
3. 读取当天数据
4. 按你的提示，输出没打卡的人名

这些步骤里任何一环出问题，它会自己分析原因，重试。这就是 Agentic Workflow 对普通 Workflow 的最大优势。

## 二、Codex CLI / Claude Code

若改为 Codex CLI 或 Claude Code，将可以用脚本/命令行，来指定它们进入文件夹，跑完上面的流程，自己退出。

把这个脚本/命令，用系统的计划任务，每天定时跑一次。

这样，就完成了第二次 Loop Engineering 壮举，同时，前台妹子表示：很，开，心！

![前台妹子让 AI 统计打卡，Agent Loop 连接服务器、电费账单和资源循环](agentic-workflow-front-desk-attendance-loop.png)


## 三、开始膨胀

做完这些，你开始膨胀，想要这个 Agentic Workflow 帮前台妹子跑一万年。但发现，电脑会关机、公司会停电。

于是搞了很多服务器，分布在全球各地，每个都安装 Codex CLI 或 Claude Code，让它们像「僵尸网络」一样运行，别说停机，就是连 FBI 想要上门来主动关闭，都会感觉力不从心。

但你感觉老费钱，于是让这个「僵尸网络」时不时问前台妹子要点，以及自己去互联网上找点业务，养活自己，买更多服务器扩充自己。

“要是养不活，不够钱买服务器，你就自己停机吧！”

## 四、很多年以后

前台妹子都升成高管御姐了。

你和她的小孩聊天，说：当年，你爸我就是这么把它放上互联网的，没想到成了数字生命的原始老祖。


> 你觉得，这算不算数字生命的开端？欢迎在评论区聊聊，你对 Loop Engineering 的看法。
