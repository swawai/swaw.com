---
date: "2026-07-26T13:47:31+08:00"
draft: false
title: "VS Code 新視窗，可能悄悄繼承你的金鑰"
linkTitle: "VS Code 新視窗的環境變數"
slug: "vscode-shared-env"
description: "啟動 VS Code 時注入的環境變數，可能擴散到之後開啟的所有新視窗。30 秒重現、官方隔離方式，以及我的輕量解法。"
share_image: "vscode-shared-env-zh-tw-share.png"
nav_primary: signals
intent:
 - explore
tags:
 - tooling/devtools/windows
 - ai
---


![VS Code 新視窗不等於全新環境](vscode-shared-env-zh-tw-cover.png)

## 一、30 秒自測

關閉所有 VS Code 視窗，接著在**兩個終端機裡**依序執行：

> 注意：我的環境是 Windows CMD 終端機；macOS/Linux 請改用對應的 Bash 指令。

```cmd
:: 終端機1：設定一個假的 Key，並開啟第一個 VS Code 視窗
set MY_API_KEY=abcdefghijklmn && code C:\

:: 終端機2：開啟第二個 VS Code 視窗
code D:\
```

在第二個視窗的終端機裡執行：

```
cmd /c set MY_API_KEY
```

你會看到什麼？它明明不該出現在這裡，卻偏偏出現了：

![VS Code 意外暴露繼承的環境變數](vscode-shared-env.png)


**我也測過 Cursor（`--classic` 模式），同樣可以重現。其他以 VS Code 為基礎的 IDE 可能也有相同行為！後文只以 VS Code 為例，不再重複說明。**


## 二、為什麼會這樣

原因其實很簡單：

VS Code 可以同時開啟多個視窗。這些視窗看起來彼此平行，背後卻共用同一個主處理程序。新視窗實際上都是由主處理程序建立，自然也會繼承它的環境。

那麼，主處理程序什麼時候啟動，又在什麼時候結束？

在我測試的 Windows 上，開啟第一個 VS Code 視窗時，主處理程序會跟著啟動；直到最後一個 VS Code 視窗關閉，主處理程序才會結束。

所以，第一個視窗是由誰開啟的，就非常關鍵：它所攜帶的環境變數，會被注入 VS Code 的主處理程序。

如果你從帶有 API Key 的終端機開啟第一個視窗，那麼不好意思，這組 Key 就會成為之後所有新視窗的共用資源。

環境變數已經被注入主處理程序，該怎麼辦？關閉所有 VS Code 視窗，讓主處理程序結束。


## 三、我去回報了一個 Issue，你猜官方怎麼回？

Issue 在這裡：https://github.com/microsoft/vscode/issues/327454

對方：See https://code.visualstudio.com/docs/configure/command-line#_isolating-vs-code-instances

我原本以為是 Bug，對方的意思似乎是：這是 Feature🫠？

這個行為確實寫在官方文件裡。文件建議為每個實例另外指定 `--user-data-dir`：

```cmd
code ~/project1 --user-data-dir ~/vscode-data-project1
code ~/project2 --user-data-dir ~/vscode-data-project2
```

為了隔離環境變數，建立多個 user-data-dir……

這也代表 VS Code 設定、擴充套件、快速鍵、歷史紀錄等都會彼此分開。每開一個新專案，就得重新安裝擴充套件、設定佈景主題，還要記住哪個視窗使用哪一套 user-data-dir。

**這哪是在隔離環境變數？我看是想讓人原地轉行 DevOps！**


## 四、我的輕量解法

### 1. 最簡單的避開方式

每次執行 `code .` 之前，如果沒有其他 VS Code 視窗已經開著，就先從開始功能表開啟一個。確保主處理程序不是由你的 `code .` 啟動，之後再開多少個視窗都不會帶入啟動專案時的終端機環境。

### 2. 包裝一個專用指令碼，把啟動 `code .` 的流程拆成兩個階段

```text
載入環境變數前：
    檢查 VS Code 是否已經執行
    如果沒有，先開啟一個空白視窗（這會啟動主處理程序）

主處理程序啟動後：
    載入環境變數
    接管空白視窗
    載入專案目錄（code --reuse-window "專案目錄"）
```

兩種方法的邏輯完全相同：確保主處理程序已經在「別處」啟動。我日常使用的是指令碼方案，一次處理、長期省事；如果你只是偶爾遇到這個問題，記得先開一個空白視窗就夠了，不必弄得太複雜。


參考程式碼：https://github.com/swawai/swaw-kit/tree/main/_lib/editor_kit

> macOS/Linux 的思路相同，差別只在指令碼寫法。歡迎在留言區分享你的實作。

## 五、所以你現在該做什麼

1. 花 30 秒執行一次上面的自測。
2. 日常使用時，在 `code .` 之前先確認已有其他 VS Code 視窗開著。
3. 如果你經常在終端機裡 export/set 金鑰後啟動 VS Code，可以考慮使用上面的包裝指令碼邏輯。
4. 這不是什麼驚天漏洞。洩漏只會發生在同時開啟的多個 VS Code 視窗之間，但它足夠隱蔽：你在 A 專案設定了公司的 OpenAI API Key；切到 B 專案後，以為只會使用 DeepSeek，某段程式碼卻拿著殘留的 Key 執行……月底看到帳單時才發現：咦，怎麼又多了幾百美元。
