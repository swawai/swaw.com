---
date: "2026-07-22T16:41:59+08:00"
draft: false
title: "Git 多帳號管理，如何像鐵一樣清楚"
linkTitle: "Git 多帳號管理"
slug: "swaw-kit-git"
description: "同時使用多個 GitHub 或 GitLab 帳號時，commit 署名與 push 身分很容易混在一起。Swaw Kit Git 將每套身分收束成一個專用命令，也能用於 VS Code、Cursor 和 AI Agent。"
share_image: "swaw-kit-git-zh-tw-share.png"
nav_primary: signals
intent:
 - explore
tags:
 - tooling/devtools/windows
---



![Swaw Kit Git 讓每套 Git 身分都有自己的命令](swaw-kit-git-zh-tw-cover.png)

AI Coding 越來越強，手上維護的程式碼儲存庫也很容易變多。這些儲存庫還可能分屬不同的 GitHub 帳號，例如公司帳號、個人帳號，甚至位於 GitLab。

## 一、會遇到什麼問題？

假設你有兩個儲存庫：

```text
儲存庫 A → https://github.com/userA/repoA.git → 屬於個人帳號 userA
儲存庫 B → https://github.com/company/repoB.git → 需要使用公司帳號 userB
```

剛 push 完儲存庫 A，接著 push 儲存庫 B 時，很容易看到「沒有權限」的錯誤；
刪除 userA 的認證、登入 userB 後，儲存庫 B 可以正常 push，儲存庫 A 卻又報錯。
更糟的是，push 雖然成功，事後才發現自己把個人用的署名與信箱提交到了公司的儲存庫。

> `user.email` 設定的作者信箱，與 push 使用的遠端存取身分，是互不相干的兩套機制，後面還會進一步說明。

## 二、每次都要頻繁切換嗎？

那實在太痛苦了。熟悉 Git 的人通常會利用兩層 Git 設定檔：

```text
全域設定：
~/.gitconfig

儲存庫內設定：
儲存庫 A/.git/config
儲存庫 B/.git/config
```


## 三、如何用 Git 設定檔分開遠端存取身分與署名？

只要修改儲存庫內的設定，建議直接使用命令：

```cmd
cd D:\code\repoA
git config user.name "Personal Name"
git config user.email "personal@example.com"
git config credential.https://github.com.username userA
```

```cmd
cd D:\code\repoB
git config user.name "Company Name"
git config user.email "name@company.com"
git config credential.https://github.com.username userB
```

設定後，這些資訊會分別寫入兩個儲存庫的 `.git/config`，彼此不會干擾。

之後，在儲存庫 A 中執行的 Git 命令，會自動套用 `儲存庫 A/.git/config`；
在儲存庫 B 中執行的命令，則會套用 `儲存庫 B/.git/config`。
VS Code 的原始碼控制功能也會呼叫 Git，因此同樣會讀取這些設定。
如此一來，每個儲存庫就能在 Git 底層自動套用自己的署名，並指定不同的遠端存取身分。

> 儲存庫內的 `.git/config` 優先於全域的 `~/.gitconfig`。


## 四、三條設定命令詳解

### 1. 前兩條命令

這兩條命令會設定作者署名與信箱。執行 `git commit` 時，Git 會自動附加這些資訊：

```cmd
git config user.name "Personal Name"
git config user.email "personal@example.com"
```


### 2. 第三條命令

這條命令會告訴 HTTPS 認證協助工具，遠端存取時要使用哪個帳號。

`儲存庫 A` 指定存取 `github.com` 遠端時使用 `userA`：

```cmd
git config credential.https://github.com.username userA
```

`儲存庫 B` 則指定使用 `userB`：

```cmd
git config credential.https://github.com.username userB
```

這裡假設儲存庫的 origin URL 是 HTTPS 連結，設定的也是 HTTPS 遠端存取帳號。
它只負責指定帳號。在 Windows 的 Git for Windows 環境中，第一次 push 時通常會開啟瀏覽器要求登入授權；成功後，認證資訊會由 Windows `認證管理員` 保存。
**如果 origin URL 從未修改，它就是你 clone 儲存庫時使用的 URL。**


## 五、如果儲存庫的 origin URL 是 SSH 連結呢？

### 1. 將 SSH 連結轉換成 HTTPS

```cmd
cd D:\code\repoA
:: 查看目前的 origin URL：
git remote get-url origin
:: 假設 SSH 連結是 git@github.com:path/repoA.git，執行：
git remote set-url origin https://github.com/path/repoA.git
```

### 2. 或為不同儲存庫設定不同的 SSH 私密金鑰

```cmd
cd D:\code\repoA
:: 假設私密金鑰位於 %USERPROFILE%/.ssh/id_ed25519_userA：
git config core.sshCommand "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_userA"

cd D:\code\repoB
:: 省略
```

> GitHub 與 GitLab 會依私密金鑰辨識 SSH 存取身分，而不是依帳號名稱。

### 3. 如果一個 origin 有多個 URL，而且需要不同的遠端存取身分呢？

HTTPS URL 可以直接把帳號名稱加入 URL；SSH URL 則可以在 `~/.ssh/config` 中，將私密金鑰包裝成一個 `Host`，再用這個別名取代 URL 中原本的主機名稱。這種情況相當少見，這裡就不展開說明。

## 六、為什麼要區分作者署名與遠端存取身分？

建立 GitHub 或 GitLab 帳號時會被要求填寫信箱，因此很多人會以為：

```cmd
git config user.email "name@example.com"
```

設定作者信箱的同時，也指定了 push 使用的遠端帳號。

這個理解是錯的，我也曾經困惑過。實際上，它們是完全不同的兩套機制：

```text
程式碼是誰寫的  （作者署名與信箱）
誰有權限 push   （遠端存取身分）
```

例如，你可能用個人 GitHub 帳號維護公司的專案，但 commit 署名必須使用公司信箱。如果不能分開設定，就無法做到這一點。

## 七、全域設定有什麼用？

前面的署名命令會修改儲存庫內的 `.git/config`。加上 `--global` 後，則會寫入全域的 `~/.gitconfig`：

```cmd
git config --global user.name "Default Name"
git config --global user.email "default@example.com"
```

之後新增一個沒有本機設定的 `儲存庫 C`，就會自動套用全域設定。使用多個 Git 帳號時，這份便利也可能讓身分資訊更容易混亂。

## 八、Git 原生還有更方便的方式嗎？

逐一設定每個儲存庫的好處是非常清楚，代價則是每新增一個本機儲存庫，都得重新設定一次。

Git 還有另一個方法：`includeIf`。

### 1. 將需要不同遠端身分與署名的儲存庫放在不同父資料夾

例如：

```text
D:/github-userA/
  └─儲存庫 A
D:/github-userB/
  └─儲存庫 B
```

### 2. 把設定寫入各自的父資料夾

以 `github-userA` 為例：

```cmd
git config --file "D:/github-userA/.gitconfig" user.name "Personal Name"
git config --file "D:/github-userA/.gitconfig" user.email "personal@example.com"
git config --file "D:/github-userA/.gitconfig" credential.https://github.com.username userA
git config --file "D:/github-userA/.gitconfig" core.sshCommand "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_personal"
```

`github-userB` 則是：

```cmd
git config --file "D:/github-userB/.gitconfig" user.name "Company Name"
git config --file "D:/github-userB/.gitconfig" user.email "name@company.com"
git config --file "D:/github-userB/.gitconfig" credential.https://github.com.username userB
git config --file "D:/github-userB/.gitconfig" core.sshCommand "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_company"
```

上面的範例也設定了 `sshCommand` 和 SSH key，在 origin URL 使用 SSH 連結時會派上用場。
**其中的資料夾路徑、SSH key 路徑、`user.name`、`user.email`、`userA`、`userB`，都請依實際情況替換。**

> origin 是 SSH URL 時會採用 `core.sshCommand`；是 HTTPS URL 時則使用 `credential.*`。
> 如果 origin URL 從未修改，它就是你 clone 儲存庫時使用的 URL。

### 3. 掛載到全域設定

將剛才產生的 `D:/github-userA/.gitconfig` 與 `D:/github-userB/.gitconfig`，按條件掛載到全域設定 `~/.gitconfig`：

```cmd
git config --global "includeIf.gitdir/i:D:/github-userA/.path" "D:/github-userA/.gitconfig"
git config --global "includeIf.gitdir/i:D:/github-userB/.path" "D:/github-userB/.gitconfig"
```

這樣就完成了。

今後在 `D:/github-userA` 下的儲存庫中執行 Git 命令，會自動套用 `D:/github-userA/.gitconfig`；
在 `D:/github-userB` 下的儲存庫中操作，也會自動套用另一份設定。
透過 VS Code 操作也不例外。


## 九、還是覺得麻煩，怎麼辦？

我的解法是 **Swaw Kit Git**（入口模板為 `Favorites/template.git1.cmd`）。

**把每套身分包裝成不同的 Git 入口命令：**

```text
gitme.cmd      個人身分
gitwk.cmd      公司身分
gitme2.cmd     第二套個人身分
```

用 `gitme` 身分操作儲存庫 A：

```cmd
cd repoA/
gitme commit -m "update"
gitme push
```

用 `gitwk` 身分操作儲存庫 B：

```cmd
cd repoB/
gitwk push
```

以 `gitwk` 身分啟動 VS Code 或 Cursor：

```cmd
cd repoB/
gitwk .code
gitwk .cursor
```

將 `gitwk` 綁定的身分持久寫入儲存庫 B 的 `.git/config`：

```cmd
cd repoB/
gitwk .sync
:: 之後也可以清除受管理的設定：
gitwk .sync --clear
```

工具會透過環境變數注入身分資訊，不影響其他處理程序或視窗，也不會暗中修改任何 Git 設定檔；除非你明確執行會修改設定的命令，例如 `gitme .sync`。

以點號開頭的是自訂命令，例如 `.code`、`.cursor`；沒有點號開頭的命令，例如 `commit`、`push`，則會在驗證並加入身分環境變數後，轉交給 `git.exe` 執行。

它的行為會像鐵一樣頑固：
透過 `gitme` 執行的操作，一定使用 `gitme.cmd` 綁定的身分；
透過 `gitwk` 執行的操作，也一定使用 `gitwk.cmd` 綁定的身分。
除非你使用參數明確覆寫，例如：

`gitme commit --author=...`

**無法明確判斷該使用哪套身分時，它寧可報錯，也不會繼續執行。**

## 十、Swaw Kit Git 使用畫面

以我的 `gitme.cmd` 為例，它綁定的身分是：

```text
作者署名：Tom
署名信箱：Tom@swaw.com
遠端存取帳號：orwithout（HTTPS，github.com）
```

VS Code 介面顯示的登入帳號是：

```text
swawai（GitHub）
```

先執行 `gitme .info` 查看綁定的身分：

![gitme .info 顯示作者 Tom、信箱 Tom@swaw.com，HTTPS 授權帳號為 orwithout](gitme-info.png)



用 `gitme` 身分啟動 VS Code，並開啟測試儲存庫：

```cmd
gitme .code D:\test\test_repo
```

分別透過 VS Code 圖形介面與整合式終端機完成一次 commit 和 push。畫面中，VS Code 介面的帳號仍然是 `swawai`：


![VS Code 顯示帳號 swawai，同時透過圖形介面與終端機使用 gitme 完成 commit 和 push](gitme-vscode-push.png)

開啟 GitHub，查看辨識到的 push 帳號與 commit 署名。它們與 `gitme.cmd` 綁定的設定完全一致，也沒有受到 VS Code 登入帳號影響：


![GitHub 儲存庫動態顯示由 orwithout 帳號完成 push](github-push-account.png)

![GitHub commit patch 的 From 欄位顯示作者 Tom、信箱 Tom@swaw.com](github-commit-author.png)



## 十一、工具已開源，免安裝，上手只要三步

Git 本身，也就是 Git for Windows，仍需自行安裝。

### 1. Clone 儲存庫

```cmd
git clone https://github.com/swawai/swaw-kit
cd swaw-kit
```

### 2. 建立身分專用的入口命令

以下以建立 `gitme2` 為例：

```cmd
copy .\Favorites\template.git1.cmd .\gitme2.cmd
```

開啟複製得到的 `gitme2.cmd`，修改三個必填值：

```cmd
:: commit 署名：
set "GIT_ID_NAME=Your Name"
set "GIT_ID_EMAIL=you@example.com"

:: 遠端存取方式（這裡使用 HTTPS GitHub 模式）：
set "GIT_ID_ACCESS=https.github:host=github.com;account=your-account"
```

遠端存取支援 `https.github:`、`https.gitlab:`、`ssh:` 三種模式，實際設定時可以查看 `gitme2.cmd` 中的註解。使用任一 `https.*` 模式前，需要先執行一次：

```cmd
gitme2 .https login
```

這會開啟瀏覽器互動流程，進行一次認證授權。

身分設定只有這些。執行：

```cmd
gitme2 --help
```

即可查看所有可用命令。

### 3. 加入使用者 PATH

要讓 `gitme`、`gitme2` 等命令能直接在任何終端機與 `Win + R` 中執行，請雙擊儲存庫根目錄中的：

```cmd
PathHereAdd.cmd
```

它會把目前工作目錄，也就是儲存庫根目錄，加入使用者 `PATH`。要復原，請執行 `PathHereRemove.cmd`。

這個指令碼修改使用者 `PATH` 是否安全可靠？請參考[讓 Win + R 執行自訂命令](/zh/p/win-run-custom-command-path/)。




## 十二、小結

Git 多帳號管理真正麻煩的，不是帳號很多，而是能改寫身分的地方很多：全域設定、儲存庫設定、認證管理員、SSH key，甚至 VS Code 之類的編輯器。
Git 原生設定完全能解決問題；但儲存庫與身分繼續增加後，你會開始懷疑：這個儲存庫設定過了嗎？現在的身分資訊究竟來自哪裡？

**Swaw Kit Git** 將這些隱藏狀態收束成一個個專用、可命名的入口命令：
`gitme` 就是個人身分，`gitwk` 就是工作身分。命令還沒執行，身分已經清楚可見。命令名稱記不住？你可以依喜好自行重新命名。


用 Codex 的話概括：

> 對人來說，入口命令是容易記住的操作介面；對 Agent 來說，它是參數明確、失敗可判斷的執行介面。雙方走的是同一條主路徑，不需要維護兩套身分規則。

> 關聯儲存庫：https://github.com/swawai/swaw-kit

在除錯 **Swaw Kit Git** 的過程中，我發現 VS Code 有個會在視窗之間洩漏環境變數的隱密問題。下一篇文章會說明這個行為，以及我的應對方式。
