---
date: "2026-06-10T11:42:11+08:00"
draft: false
title: "讓 Win + R 執行自訂命令：一個加入 PATH 的小工具"
linkTitle: "讓 Win + R 執行自訂命令"
slug: "win-run-custom-command-path"
description: "用兩個小工具把工具所在目錄加入或移出使用者 PATH，讓 Win + R 可以執行自己的 .cmd、.bat 與 .exe 命令，形成個人 Windows 工具箱。"
share_image: win-run-custom-command-path-zh-tw-share.png
nav_primary: signals
intent:
 - explore
tags:
 - tooling/devtools/windows
---




![讓 Win + R 執行自己的命令文章封面](win-run-custom-command-path-zh-tw-cover.png)


Windows 的 `Win + R` 很好用，但多數時候，我們只拿它執行 `cmd`、`ncpa.cpl`、`mstsc`、`services.msc` 這些系統內建命令。

其實，只要把自己的工具目錄加入 `PATH`，也能透過 `Win + R` 執行。

例如我長期使用的自訂與第三方工具：

```text
hosts.cmd      開啟 hosts 檔案
git1.cmd       使用 SSH 金鑰 1 執行 Git 命令
git2.cmd       使用 SSH 金鑰 2 執行 Git 命令，管理多個 Git 上游帳號
vps1.cmd       透過 SSH 登入 VPS 1
vps2.cmd       透過 SSH 登入 VPS 2
bun            JavaScript 執行環境
uv             Python 套件與專案管理工具
……
portrule.cmd   快速管理 Windows 防火牆連接埠放行規則
porttask.cmd   依服務連接埠查詢處理程序
taskport.cmd   依處理程序 ID 查詢服務連接埠
psping.exe     Sysinternals TCP ping 工具
tcpview.exe    Sysinternals 連線檢視工具
Autoruns.exe   Sysinternals 啟動項目疑難排解工具
```

不用開啟「開始」功能表，不用找捷徑，也不用切換到特定目錄，只要記得命令名稱。

背後的核心機制就是 `PATH`。

輸入一個命令時，系統會依序在 `PATH` 記錄的目錄裡，尋找對應的 `.exe`、`.cmd`、`.bat` 等可執行檔。只要某個目錄在 `PATH` 裡，其中的指令碼與工具就能像系統命令一樣被呼叫。

所以，關鍵問題就變成：

```text
如何快速把一個目錄加入 PATH？
```

## 一、我做了兩個小工具

```text
PathHereAdd.cmd       加入使用者 PATH
PathHereRemove.cmd    從使用者 PATH 移除
```

兩個工具只會作用於自身所在的目錄，而且會明確拒絕參數，避免「目前工作目錄」與目標目錄不一致。

> 工具已上傳 GitHub，儲存庫連結在文末。

使用方式：

1. 複製 `swaw-kit` 儲存庫，例如放在 `C:\swaw-kit`。
2. 按兩下 `PathHereAdd.cmd`。

工具會檢查這個工具箱目錄是否已在目前使用者的 `PATH` 中；若不存在，才會附加進去。

接著開啟新的終端機，或重新叫出 `Win + R`，變更就會生效。

要復原，只需按兩下同一目錄裡的 `PathHereRemove.cmd`，它會執行 `PathHereAdd.cmd` 的反向操作。


## 二、會不會改壞 PATH？

`PATH` 是重要的環境變數，因此工具在加入或移除目標項目時，設置了多層保護：

```text
1. 只修改目前使用者 PATH，不碰系統 PATH
2. 加入前先檢查是否已存在，避免重複加入
3. 寫入前備份原始使用者 PATH
4. 只修改要加入或移除的目錄項目；其他項目維持原樣
   （例如 `%USERPROFILE%\bin` 不會被展開成固定路徑）
5. 支援空格、中文、&、%、!、括號等路徑字元
6. 移除時先依分號把 PATH 拆成各個目錄項目，再比對完整項目；
   因此移除 `C:\Tools` 時，不會誤傷 `C:\ToolsExtra`
7. 如果同一個目錄重複出現，移除工具會清掉所有相符項目
8. `data/PathHere.backup.log` 會保存每次操作前的原始使用者 `PATH`，作為最後保障
```

> `PATH` 本身使用分號分隔目錄項目，因此工具箱目錄名稱不可包含分號。

## 三、它真正改變的不是 PATH

這兩個工具很小，真正有用的是它們帶來的工作方式。像我就維護了一個工具箱目錄：

```text
C:\swaw-kit
```

把常用命令與自己寫的 `.cmd` 捷徑指令碼都放進去。如此一來，按下 `Win + R` 後輸入檔名、按 Enter，就能啟動。

當然，在命令列終端機裡直接輸入檔名，也能以同樣方式呼叫。

## 四、邊界與風險

1. 修改環境變數後，已經開啟的終端機通常不會自動重新整理。新開啟的終端機與新啟動的程式，才會讀取更新後的使用者環境變數。

2. 不建議把太多目錄加入 `PATH`。最好只加入一個穩定的工具箱目錄，作為自己的命令命名空間；目錄越多，越容易發生命令名稱衝突。

## 總結

這兩個工具並不複雜，卻很像一個入口開關。

把高頻動作變成命令，把命令放進穩定的目錄，再從 `Win + R`、終端機或其他指令碼統一呼叫。

對我而言，這不是在折騰 `PATH`，而是在替 Windows 補上一層自己的操作介面。

> 工具儲存庫：[swawai/swaw-kit](https://github.com/swawai/swaw-kit)
