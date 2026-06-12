---
date: "2026-06-12T17:56:53+08:00"
draft: false
title: "CoSkill：人機協作的未來"
slug: "coskill-trustworthy-collaboration"
description: "從 Anthropic Skills 出發，提出 CoSkill：一種人類和 agent 都能使用的能力單元。"
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

# 人機協作的未來，Skills 一葉知秋

讓 AI/agent 自主發揮的空間小一點，工具化和固化的流程多一點，人類被取代的命運就會離現實更遠一點。

![CoSkill，人機協作的未來](coskill-trustworthy-collaboration.png)

## 一點微妙分歧

Anthropic 提出的 Skills，核心是[增強模型與 agent 的能力](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)：[讓模型可以按需載入操作說明、呼叫工具](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)。

這固然重要，但對人類使用者來說，更在乎的是，任務是否能按預期、穩定地完成。

一個經常性任務，人們更希望它穩定、按部就班地完成交付，並不想模型/agent 每次都搞出新東西。

所以，除非是探索、研究型任務，否則 Skills 才是更核心的。

這是 agent 日常使用者和大型模型公司之間一點微妙的心理分歧。

## Skills 不該只是 AI 的外掛，也該是人類的底座

有人為 Codex / Claude Code 掛載上百個 Skills，但並不了解模型使用它們的具體細節。

Skills 往往是操作具體對象，例如改動一個程式碼專案，或呼叫某個接口進行付款下單。

今天，很少聽說人類可以越過 agent，直接自己操作或編排 Skills。

我們的很多能力，本來就是工具賦予的。

人類沒有猛獸強壯，卻藉助工具改變了世界。

如果面向人類的工具不落後於面向 AI 的工具，我們也未必會落後於 AI。

## 我們不能參與改進大型模型，但可以參與改進 Skills

我們很難修改大型模型；至於商用模型，可能連議價權都沒有。

Skills 不同。這是 Claude 文件裡的示例 Skill：

```text
pdf-skill/
├── SKILL.md (main instructions)
├── FORMS.md (form-filling guide)
├── REFERENCE.md (detailed API reference)
└── scripts/
    └── fill_form.py (utility script)
```

其中 `.md` 文件裡都是文本，`scripts` 中是程式碼，幾乎人人都可以改。

## 對 Skills 的使用，是一種有價值的經驗

隨著數位世界和 agent 生態繁榮，達成一個目標的路徑，往往會變得不只一條。

有的鳥類用蘆葦織巢，有的獸類倒掛著睡覺，蘇美人把記錄寫在泥板上，中國人用陶瓷做水缸……

大型模型/agent 公司，很容易收集使用者用了什麼 Skills、如何使用，然後改進自家模型的能力。

如果對 Skills 或 agent 做一點點規範：

1. 記錄 Skills 中各個能力的使用頻率、順序路徑；
2. 記錄各個能力被使用後的效果，是成功，還是失敗。

我們完全可以形成自己的數位世界經驗資產，而不必與某家特定的大型模型/agent 綁定。

## 我提出 CoSkill 概念

一種人類和 agent 都能使用的能力單元。

它大概包含：

1. Agent 可讀取的執行說明與接口（Skills）；
2. 人類可理解的操作介面與狀態視圖（App）；
3. 兩者共通的日誌、權限、審批層。

在具體執行上，也可以把每一次可執行操作稱為 **CoAction**。

一個 CoAction 既可以由 agent 發起，也可以由人類發起；既可以自動運行，也可以被人類審查、審批或接管。

這也在提醒 agent：你的操作不是隱秘發生，而是會被記錄。

所以 CoSkill 不只是工具方案，也是一種人機協作的設計理念。

## Skills WorldTree，CoSkill 的後續

CoSkill 變多後，可以考慮：

1. 統一 UI 協議，使一個類似「瀏覽器」的工具可以展示所有 CoSkill 的 UI；
2. 聚合海量 CoSkill，統一分類、索引與編排；這個介面可以以人類操作為中心，agent 作為輔助，例如彌合 Skills 之間的「間隙」。

## 一葉知秋

未來已至。Skills 的存在方式，已經可以視為人機協作紀元的風向標。

如果我們只為 AI 構建越來越強的工具，卻不給人類留下同等強大、可介入的介面，那麼所謂協作很快就會滑向取代。

問題不是 AI 要不要變強。

問題是，當 AI 變強時，人類是否仍然能站在同一個行動面上。
