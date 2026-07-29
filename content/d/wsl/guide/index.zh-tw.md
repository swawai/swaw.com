---
date: "2025-04-02T22:04:00+08:00"
lastmod: "2026-06-01T00:07:12+08:00"
draft: false
title: "WSL 實戰指南：安裝、遷移、備份與常用設定"
linkTitle: "WSL 實戰指南"
slug: "wsl-guide"
aliases:
 - /p/wsl-practical/
description: "整理 WSL 在 Windows 10/11 上的安裝、版本切換、執行個體管理、備份還原、遷移、鏡像網路、離線安裝與常用設定。"
share_image: wsl-guide-zh-tw-share.png
nav_primary: signals
intent:
 - explore
tags:
 - tooling/devtools/windows/wsl
---

> 本文聚焦 WSL 的手動安裝、備份／還原、遷移與常用情境。如果想用一個命令管理一個執行個體，可參考 [SWAW Kit WSL 一鍵管理工具](/zh-tw/p/swaw-kit-wsl-release/)。

> WSL 是 Windows Subsystem for Linux 的縮寫，可以讓我們在 Windows 10/11 上直接執行 Linux 環境。它帶來的好處包括：
>
> 1. **檔案互通**：使用 Linux 軟體處理 Windows 檔案，或反過來。例如用 awk 編輯 Windows 的記錄檔，或在 VS Code／Cursor 上偵錯 Linux 環境中的專案。
> 2. **systemd 服務管理**：啟用 systemd 後，WSL 執行個體運作期間可以像傳統 Linux 一樣管理服務；但 systemd 服務本身不等於讓執行個體保持運作。
> 3. **顯示 GUI 程式**：透過 WSLg 直接在 Windows 上執行 Linux GUI 程式。
> 4. **執行 Linux 容器**：Windows 上的 Docker 也以 WSL2 為基礎，可以輕鬆管理各種容器。
> 5. **多個 Linux 系統並存**：同時擁有 Ubuntu、Debian、Arch 等發行版。
> 6. **支援 GPU**：使用 [NVIDIA CUDA](https://learn.microsoft.com/windows/ai/directml/gpu-cuda-in-wsl) 等硬體加速。
> 7. **程式碼已開源**：WSL 已在 [microsoft/WSL](https://github.com/microsoft/WSL) 開源。

以下整理從安裝到進階使用的一系列技巧，協助你充分發揮 WSL 的能力。

---

![WSL 實戰指南：安裝、遷移、備份與常用設定](wsl-guide-zh-tw-cover.png)

## 目錄

1. [準備工作與基本概念](#1-準備工作與基本概念)
2. [安裝與初次體驗](#2-安裝與初次體驗)
3. [WSL 版本與功能設定](#3-wsl-版本與功能設定)
4. [執行個體管理：啟動、使用、關閉與解除安裝](#4-執行個體管理啟動使用關閉與解除安裝)
5. [資料管理：備份、還原與遷移](#5-資料管理備份還原與遷移)
6. [WSL2 底層原理與網路設定](#6-wsl2-底層原理與網路設定)
7. [離線安裝方式](#7-離線安裝方式)
8. [常用技巧與進階](#8-常用技巧與進階)

---

## 1. 準備工作與基本概念

### 1.1. 前提條件

- **Windows 版本**：建議使用 Windows 10 2004／Build 19041 以上版本，或 Windows 11。[官方一鍵安裝命令](https://learn.microsoft.com/windows/wsl/install)從這個版本起適用；較舊的 Windows 10 需使用[手動安裝流程](https://learn.microsoft.com/windows/wsl/install-manual)，而 WSL2 至少需要 x64 Windows 10 1903／Build 18362.1049，或 ARM64 Windows 10 2004／Build 19041。
- **已在 BIOS／UEFI 中啟用 CPU 虛擬化**：WSL2 依賴虛擬化能力與 `VirtualMachinePlatform`；若未啟用，安裝或轉換成 WSL2 時通常會出現與虛擬化相關的錯誤。WSL1 不依賴輕量虛擬機器，但現代開發情境一般優先使用 WSL2。
- **優先使用 `wsl --install` 自動啟用元件**：在 Windows 10 2004+／Windows 11 上，`wsl --install` 會啟用所需的 Windows 功能並安裝預設發行版。只有在舊系統、離線環境、Windows Server Core，或安裝命令無法使用時，才建議手動執行以下 DISM 命令：

~~~
# 以系統管理員身分執行
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  # 對應的解除安裝命令：
  # dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
  # dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
~~~

若遇到問題，先執行 `winver` 確認系統版本與 Build 編號，再對照[官方文件](https://learn.microsoft.com/windows/wsl/install-manual)，並請 AI 協助排查，例如[騰訊元寶](https://yuanbao.tencent.com)。

### 1.2. 常用術語

- **WSL**：Windows Subsystem for Linux 的縮寫。
- **WSL 本體**：Windows 上負責執行 Linux 環境的元件，現在通常透過 `wsl --install`／`wsl --update` 安裝與更新；它和特定的 Ubuntu、Debian、Fedora 等 Linux 系統並不是同一件事。
- **WSL 發行版**：可安裝的 Linux 系統映像名稱，例如 `Ubuntu-24.04`、`Debian`、`FedoraLinux-42`、`archlinux` 等。
- **WSL 執行個體**：已安裝在本機、可以啟動與管理的 Linux 環境。大多數情況下，安裝發行版後會產生同名執行個體；也可以透過 `wsl --import`，從同一個映像建立多個不同名稱的執行個體。

### 1.3. 設定檔速查

| 設定檔 | 位置 | 作用範圍 | 常見用途 | 生效方式 |
|---|---|---|---|---|
| `/etc/wsl.conf` | WSL 執行個體內 | 目前的 Linux 執行個體 | 預設使用者、systemd、自動掛載、Windows 互通 | 重新啟動目前的執行個體，或執行 `wsl --shutdown` |
| `%UserProfile%\.wslconfig` | Windows 主機的使用者目錄 | 目前 Windows 使用者下的所有 WSL2 執行個體 | 網路模式、DNS、記憶體／CPU、預設 VHD 大小、閒置逾時 | 執行 `wsl --shutdown` |

> 判斷原則：單一 Linux 執行個體的行為放在 `/etc/wsl.conf`；WSL2 底層虛擬機器或所有執行個體共用的行為放在 `.wslconfig`。
> 新版 WSL 也提供圖形設定入口：在開始功能表搜尋 `WSL Settings`。它適合修改部分 WSL 全域設定；執行個體內部設定仍以 `/etc/wsl.conf` 為準：
> ![Windows 上的 WSL Settings](image.png)

---

## 2. 安裝與初次體驗

> 以下命令可在 **Windows Terminal**、**CMD** 或 **PowerShell** 中執行。首次安裝若需要啟用 Windows 功能，建議以系統管理員身分執行終端機。
> 若尚未安裝 [Windows Terminal](https://learn.microsoft.com/windows/terminal/)，可到 Microsoft Store 搜尋：
> ![在 Microsoft Store 搜尋 Windows Terminal](./1.2.1.winterminal.store.webp "在 Microsoft Store 搜尋 Windows Terminal")

### 2.1. 一鍵安裝

~~~
# 安裝 WSL 本體與預設的 Ubuntu 發行版
wsl --install
  # 對應的解除安裝命令：
  # wsl --unregister Ubuntu  # 請小心，這會刪除名為 Ubuntu 的 WSL 執行個體
~~~

首次啟動新安裝的發行版時，WSL 會等待解壓縮與初始化，接著提示你建立 Linux 使用者名稱與密碼。

![網路受限時執行 wsl -l -o 的錯誤畫面](./1.2.2.wsl-l-o.err.webp)

> 若 `wsl --install` 只顯示說明，通常表示 WSL 本體已安裝。可改用 `wsl -l -o` 查看線上發行版，再用 `wsl --install -d <發行版名稱>` 安裝指定發行版。若安裝卡在 `0.0%`，或無法取得線上清單，可嘗試 `wsl --install --web-download -d <發行版名稱>`；如果網路仍受限，再到 Microsoft Store 搜尋對應發行版，或參考 [7. 離線安裝方式](#7-離線安裝方式)。上圖是網路受限時可能出現的錯誤。

### 2.2. 安裝其他發行版

~~~
# 列出可用發行版
wsl -l -o

# 安裝指定發行版。名稱以 wsl -l -o 的實際輸出為準
wsl --install -d Ubuntu-24.04

# 安裝新執行個體時也可直接指定位置，減少後續遷移
wsl --install -d Ubuntu-24.04 --location D:\wsl\Ubuntu-24.04

# 也可以是：
# wsl --install -d Ubuntu-26.04
# wsl --install -d Debian
# wsl --install -d FedoraLinux-44
# wsl --install -d archlinux
  # 對應的解除安裝命令
  # wsl --unregister Ubuntu-24.04
~~~

> 發行版名稱會隨時間更新，不要死背版本號；以 `wsl -l -o` 的輸出作為單一事實源。`--location` 適合在安裝新執行個體時規劃資料磁碟位置；若已經安裝完成，再參考 [5.4. 遷移到新位置](#54-遷移到新位置)。若線上安裝失敗，同樣可嘗試 `--web-download`、Microsoft Store 或離線安裝。目前官方線上清單來自 [DistributionInfo.json](https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json)，其中包含 Ubuntu、Debian、Fedora、Arch、openSUSE、SUSE、Kali、AlmaLinux 等發行版的下載網址。

---

## 3. WSL 版本與功能設定

WSL 發行版可以使用 **WSL1** 或 **WSL2** 兩種執行模式，兩者可以並存。新安裝的發行版通常預設使用 WSL2；它執行真正的 Linux 核心，對 systemd、Docker 等情境的相容性較好，建議優先使用。WSL1 的主要優勢是跨 Windows 檔案系統存取效能較佳，適合專案必須放在 Windows 檔案系統中的少數情境。請參考 [WSL1 與 WSL2 的比較](https://learn.microsoft.com/windows/wsl/compare-versions)。

### 3.1. 查詢與切換版本

~~~
# 查看已安裝的執行個體及其版本（不會列出其他 Windows 使用者安裝的執行個體）
wsl -l -v

# 查看 WSL 本體、核心、WSLg 等元件版本
wsl --version

# 查看預設發行版、預設 WSL 版本、核心等狀態
wsl --status
~~~

![wsl -l -v 的執行結果](./1.3.1.wsl-l-v.webp)

> `wsl -l -v` 中帶有 `*` 的是`預設`執行個體；`NAME` 欄是`執行個體名稱`，`VERSION` 欄表示該執行個體使用 WSL1 或 WSL2。`wsl --version` 查詢的是 WSL 本體與各元件的版本，不等於某個 Linux 發行版中的 Ubuntu／Debian 版本。

~~~
# 將新安裝執行個體的預設版本設為 WSL2
wsl --set-default-version 2

# 將現有執行個體轉換為 WSL2
wsl --set-version <執行個體名稱> 2
# 範例：
wsl --set-version Ubuntu-24.04 2
~~~

> WSL1／WSL2 互相轉換可能耗時很久，大型執行個體也可能因磁碟空間或檔案占用而失敗。重要的執行個體建議先依照 [5.2. 備份](#52-備份) 匯出一份快照。

### 3.2. 更新 WSL 底層元件

~~~
# 查看目前的版本詳細資料
wsl --version

# 查看目前 WSL 預設設定與核心狀態
wsl --status

# 更新 WSL 本體、核心、WSLg 等元件
wsl --update

# 若 Microsoft Store 更新來源無法使用，可改從 GitHub 下載更新
wsl --update --web-download

# 試用預覽版功能（不建議在正式或主要環境中預設使用）
wsl --update --pre-release
~~~

![wsl --version 的執行結果](./1.3.2.wsl-v.webp)

> 日常排錯優先使用穩定版 `wsl --update`；只有明確需要驗證新功能或修正時，再考慮 `--pre-release`。更新後若需要讓底層 WSL2 虛擬機器完整重新啟動，可執行 `wsl --shutdown`，再重新進入執行個體。

---

## 4. 執行個體管理：啟動、使用、關閉與解除安裝

### 4.1. 啟動／切換

~~~
# 啟動並進入預設執行個體
wsl

# 啟動預設執行個體並進入 Linux 使用者的 home 目錄
wsl ~

# 啟動並進入指定執行個體
wsl -d Ubuntu-24.04

# 以指定使用者進入執行個體
wsl -d Ubuntu-24.04 -u root
~~~

![啟動 WSL 執行個體](./1.4.1.wsl.webp)

### 4.2. 從 Windows 執行 Linux 命令

~~~
# 查詢執行個體 IP。預設 NAT 模式下常用於排查連接埠轉送
wsl -d Ubuntu-24.04 hostname -I

# 在預設執行個體中執行 Linux 命令
wsl uname -a

# 指定工作目錄
wsl -d Ubuntu-24.04 --cd "C:\" pwd

# 指定 Linux home 目錄作為工作目錄
wsl -d Ubuntu-24.04 --cd ~ pwd
~~~

### 4.3. 執行 Linux GUI 程式

例如，在預設執行個體內安裝 Chromium 瀏覽器後直接執行：

~~~
wsl
# 若不是 Ubuntu，請替換安裝命令
sudo apt update
sudo apt install chromium-browser -y
chromium-browser
~~~

![透過 WSLg 執行 Linux GUI 程式](./1.4.2.wsl.gui.webp)

> 需要 [Windows 10 Build 19044+](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps) 或 [Windows 11](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps)，而且只支援 WSL2 執行個體。若已安裝 WSL 但 GUI 無法啟動，先在系統管理員終端機執行 `wsl --update`，再執行 `wsl --shutdown` 後重新進入執行個體。WSLg 支援個別 Linux GUI 應用程式融入 Windows 桌面，但不等於完整的 Linux 桌面環境；若目前發行版的套件來源中沒有 `chromium-browser`，可改用官方 Google Chrome、Edge 或其他 GUI 程式驗證。

### 4.4. 設定預設執行個體

~~~
wsl --set-default <執行個體名稱>
# 簡寫：
wsl -s <執行個體名稱>
~~~

### 4.5. 關閉與解除安裝

~~~
# 關閉指定執行個體
wsl --terminate <執行個體名稱>
# 簡寫：
wsl -t <執行個體名稱>

# 關閉目前 Windows 使用者下的所有 WSL 執行個體，並停止 WSL2 底層輕量虛擬機器
wsl --shutdown

# 解除安裝執行個體（永久刪除資料）
wsl --unregister <執行個體名稱>
~~~

> `wsl --terminate` 會停止單一執行個體；`wsl --shutdown` 常用於修改 `.wslconfig`、更新 WSL，或需要重新啟動底層 VM 才會生效的情境；`wsl --unregister` 會永久刪除該執行個體的資料，操作前應確認已有備份。

---

## 5. 資料管理：備份、還原與遷移

> 以下操作同樣在 **Windows Terminal** 或 **PowerShell** 中執行。

### 5.1. 查看所有執行個體的安裝位置

```
# PowerShell
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\*" | Select-Object @{Name='DistributionName';Expression={$_.DistributionName}}, @{Name='BasePath';Expression={$_.BasePath}} | Format-Table -AutoSize
```

![查看 WSL 執行個體的安裝位置](./1.5.1.wsl.path.webp)

> 至少有一個執行個體時，此命令會顯示目前 Windows 使用者的 WSL 執行個體註冊資訊。這個位置適合用來確認執行個體路徑，不建議手動搬動或編輯其中的 `ext4.vhdx`。

### 5.2. 備份

~~~
# 先停止要備份的執行個體，避免寫入中的資料造成快照不一致：
wsl --terminate <執行個體名稱>

# 備份
wsl --export <執行個體名稱> <備份檔案路徑>
# 範例：
wsl --export Ubuntu-24.04 D:\backup\ubuntu2404.tar

# WSL2 也支援匯出為 VHDX，適合保留完整虛擬磁碟形式
wsl --export Ubuntu-24.04 D:\backup\ubuntu2404.vhdx --vhd
~~~

> 預設匯出格式是 tar。tar 更適合跨機器、跨發行版管理；VHDX 更接近「整顆磁碟快照」，只支援 WSL2，檔案通常也更大。

### 5.3. 還原或新增執行個體

> 可以從同一個 tar 備份檔建立多個新執行個體：

~~~
wsl --import <執行個體名稱> <安裝位置> <備份檔案路徑> --version 2
:: 範例（從備份建立兩個執行個體）：
wsl --import Ubuntu-01 D:\wsl\ubuntu-01 D:\wsl_backup\ubuntu_backup.tar --version 2
wsl --import Ubuntu-02 D:\wsl\ubuntu-02 D:\wsl_backup\ubuntu_backup.tar --version 2

:: 若備份檔案是 VHDX：
wsl --import Ubuntu-vhd D:\wsl\ubuntu-vhd D:\wsl_backup\ubuntu_backup.vhdx --vhd

:: 若已有 ext4.vhdx，只想原地註冊為新執行個體：
wsl --import-in-place Ubuntu-restored D:\wsl\ubuntu-restored\ext4.vhdx
~~~

> `--import-in-place` 要求目標是 ext4 檔案系統的 `.vhdx`。透過 `--import` 建立的執行個體，預設登入使用者可能變成 `root`；若需要恢復以一般使用者作為預設使用者，可依照 [8.1. 修改預設登入使用者](#81-修改預設登入使用者) 寫入 `/etc/wsl.conf`。

### 5.4. 遷移到新位置

~~~
wsl --manage <執行個體名稱> --move <新目錄位置>
# 範例：
wsl --manage Ubuntu-24.04 --move D:\myWSL\ubuntu2404
~~~

> `--move` 是較新的遷移主路徑。若你的 `wsl --help` 中沒有 `wsl --manage`，或移動失敗，請退回較通用的方案：先用 `wsl --export` 備份，再以 `wsl --import` 匯入新位置，確認可以啟動後，才用 `wsl --unregister` 刪除舊執行個體。目標目錄建議使用本機 NTFS 磁碟上的一般目錄，避免放在 OneDrive、網路磁碟或權限複雜的位置。

### 5.5. 擴充 WSL2 虛擬磁碟

WSL2 的 Linux 檔案系統存放在虛擬磁碟中，新版 WSL 預設最大可用空間通常是 1 TB；只有在 Linux 內部提示磁碟空間不足時，才需要手動擴充。

~~~
# 查看 Linux 內部可用空間
wsl -d Ubuntu-24.04 df -h /

# WSL 2.5+ 可直接擴充。擴充前先關閉所有 WSL 執行個體
wsl --shutdown
wsl --manage Ubuntu-24.04 --resize 2TB
~~~

> `--resize` 只適用於 WSL2，而且容量值不支援小數，例如可以寫 `512GB`、`1TB`、`2TB`，不要寫 `1.5TB`。縮小虛擬磁碟比擴充複雜許多，不建議當成日常操作。

---

## 6. WSL2 底層原理與網路設定

WSL1 在 Windows 核心上實作 Linux 系統呼叫；WSL2 則是在 Hyper-V 輕量虛擬機器中執行真正的 Linux 核心。對同一個 Windows 使用者而言，多個 WSL2 執行個體本質上是掛載在同一個 Linux 核心上的不同 rootfs；不同 Windows 使用者會各自啟動 WSL2 虛擬機器，因此看到的執行狀態與網路環境也不相同。

WSL2 預設使用 NAT 網路。Windows 本機存取 WSL2 內的 Web／API 服務時，多數情況直接使用 `localhost:<連接埠>` 即可；若需要區域網路中的其他裝置存取 WSL2 服務，傳統做法是連接埠轉送。Windows 11 22H2+ 的新版 WSL 建議優先嘗試[鏡像網路模式](https://learn.microsoft.com/windows/wsl/networking#mirrored-mode-networking)，它會把 Windows 網路介面鏡像到 Linux，改善 VPN、IPv6、多播與區域網路存取體驗。`bridged` 模式已標記為 deprecated，不建議當成新設定的主路徑。

> 以下命令都從 Windows 命令列，例如 Windows Terminal 開始執行。

### 6.1. NAT 模式下的連接埠轉送

> 預設 NAT 模式下，本機 Windows 存取 WSL 服務通常不需要連接埠轉送；只有在區域網路其他裝置需要存取 WSL2 服務時才考慮轉送，而且鏡像網路模式通常不需要這一步。

```
:: 查詢 WSL2 NAT IP：
wsl -d Ubuntu-24.04 hostname -I

:: 查看 Windows 主機現有的轉送：
netsh interface portproxy show all

:: 將 Windows 主機連接埠轉送到 WSL2：
netsh interface portproxy add v4tov4 listenport=[Windows主機連接埠] listenaddress=0.0.0.0 connectport=[WSL服務連接埠] connectaddress=[WSL2 NAT IP]
:: 範例：
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=80 connectaddress=172.29.41.233
:: 建立後，可透過【Windows主機IP:8080】存取 WSL2 中的 80 連接埠

:: 刪除主機上指定連接埠的轉送：
netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=0.0.0.0
```

> WSL2 的 NAT IP 可能在 `wsl --shutdown`、系統重新啟動或網路變化後改變；若轉送突然失效，先重新執行 `wsl -d Ubuntu-24.04 hostname -I` 檢查 IP。Linux 服務本身也必須監聽 `0.0.0.0` 或對應位址；只監聽 `127.0.0.1` 時，區域網路通常無法連線。

建立轉送後，還需要設定 Windows 主機防火牆，允許監聽的連接埠：

```
:: 允許 TCP 8080 連接埠：
netsh advfirewall firewall add rule name="WSL_TCP_8080" protocol=TCP dir=in localport=8080 action=allow
:: 允許 UDP 8080 連接埠：
netsh advfirewall firewall add rule name="WSL_UDP_8080" protocol=UDP dir=in localport=8080 action=allow

:: 列出所有防火牆規則
netsh advfirewall firewall show rule name=all
:: 依規則名稱篩選
netsh advfirewall firewall show rule name="WSL_TCP_8080"
:: 依連接埠篩選
netsh advfirewall firewall show rule name=all | findstr /R /C:"LocalPort: 8080"

:: 刪除 TCP 8080 規則
netsh advfirewall firewall delete rule name=all protocol=TCP dir=in localport=8080
:: 刪除 UDP 8080 規則
netsh advfirewall firewall delete rule name=all protocol=UDP dir=in localport=8080
```

### 6.2. 設定鏡像網路模式

鏡像網路模式需要 Windows 11 22H2+。在 Windows 主機上新增或修改 `%userprofile%\.wslconfig`：

```
[wsl2]
networkingMode=mirrored
dnsTunneling=true
firewall=true
autoProxy=true

[experimental]
hostAddressLoopback=true
```

接著重新啟動 WSL2 底層虛擬機器；這會關閉目前使用者的所有 WSL2 執行個體：

```
wsl --shutdown && wsl
```

此設定只對目前 Windows 使用者下的 WSL2 執行個體生效，不會影響其他使用者。`networkingMode`、`dnsTunneling`、`firewall`、`autoProxy` 現在屬於 `[wsl2]`；`hostAddressLoopback` 仍屬於 `[experimental]`。

> 參數說明：https://learn.microsoft.com/windows/wsl/wsl-config

常用設定的含義：

- `networkingMode=mirrored`：啟用鏡像網路。Linux 可直接使用 Windows 網路介面，通常也更容易從區域網路直接存取 WSL 服務。
- `dnsTunneling=true`：讓 DNS 要求透過 Windows 解析，對 VPN 與複雜 DNS 環境更友善；Windows 11 22H2+ 通常已預設啟用。
- `firewall=true`：讓 Windows 防火牆規則與 Hyper-V 防火牆規則參與篩選 WSL 網路流量。
- `autoProxy=true`：讓 WSL 使用 Windows 的 HTTP Proxy 資訊。
- `hostAddressLoopback=true`：選用的實驗性設定。鏡像模式原本就支援 `127.0.0.1` loopback；此設定也允許透過主機上額外配置的 IPv4 位址進行 Host ↔ WSL 互通。

設定鏡像模式後，不要簡化成「WSL2 執行個體的 IP 變成 Windows 主機 IP」。更精確的模型是：Windows 網路介面被鏡像到 Linux；Windows 與 WSL 可以透過 `127.0.0.1` 互相存取，區域網路裝置也更容易直接存取 WSL 服務。要讓區域網路電腦連線，服務本身仍應監聽 `0.0.0.0` 或對應位址，而且主機防火牆必須放行。

在 Windows 11 22H2+ 且 WSL 2.0.9+ 上，WSL 流量還會受到 [Hyper-V 防火牆](https://learn.microsoft.com/windows/security/operating-system-security/network-security/windows-firewall/hyper-v-firewall)影響；官方 [WSL 網路文件](https://learn.microsoft.com/windows/wsl/networking#wsl-and-firewall)也有說明。若鏡像模式下區域網路仍無法連線，可在系統管理員 PowerShell 中檢查或新增 WSL 專用的 Hyper-V 防火牆規則：

```
Get-NetFirewallHyperVVMCreator
Get-NetFirewallHyperVVMSetting -PolicyStore ActiveStore -Name "{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}"

# 範例：只允許 WSL 的 TCP 8080 輸入
New-NetFirewallHyperVRule -Name "WSL_TCP_8080" -DisplayName "WSL TCP 8080" -Direction Inbound -VMCreatorId "{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}" -Protocol TCP -LocalPorts 8080

# 若明確接受更大的暴露面，也可以把 WSL 預設輸入原則改為 Allow
Set-NetFirewallHyperVVMSetting -Name "{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}" -DefaultInboundAction Allow
```

> `Set-NetFirewallHyperVVMSetting ... -DefaultInboundAction Allow` 是較粗略的全面放行；個人電腦臨時測試可以使用，長期使用更建議依連接埠建立規則。在鏡像網路模式下，網路仍建立在虛擬化技術上，因此從 Windows 主機執行 `netstat -aon`，不一定能看到 WSL2 執行個體內占用的連接埠。

---

## 7. 離線安裝方式

### 7.1. 離線安裝官方發行版

此檔案包含所有官方發行版的下載網址：{{< asset src="./DistributionInfo.json" text="DistributionInfo.json" >}}

![WSL 發行版下載清單](./1.7.1.download.url.webp)

現在優先查看 `ModernDistributions` 中的 `.wsl` 下載網址。一般 x64／AMD64 電腦下載 `Amd64Url`，ARM64 電腦下載 `Arm64Url`；下載後使用以下命令安裝：

```powershell
# PowerShell。請依實際下載結果修改檔案名稱
wsl --install --from-file D:\wsl_images\ubuntu-24.04.4-wsl-amd64.wsl

# 安裝後確認執行個體名稱與 WSL 版本
wsl -l -v
```

> `.wsl` 是新版 WSL 發行版套件格式，本質上是附帶 WSL 中繼資料的 tar 發行套件。若命令顯示不支援 `--from-file`，先執行 `wsl --version`／`wsl --update` 確認 WSL 本體版本；完全離線的電腦可以先從 [WSL GitHub Releases](https://github.com/microsoft/WSL/releases) 下載最新 WSL MSI，再依官方 [Offline install](https://learn.microsoft.com/windows/wsl/install#offline-install) 步驟安裝 WSL 本體。

`.wsl` 檔案也可以按兩下安裝，但命令列方式更容易排錯：

![安裝 .wsl 發行版套件](./1.7.3.wsl.install.webp)

`DistributionInfo.json` 中也可能包含舊式 `Distributions`／`.Appx`／`.AppxBundle` 下載項目。這類檔案可按兩下安裝，或使用 PowerShell：

```powershell
Add-AppxPackage .\app_name.Appx
```

![安裝 Appx 發行版套件](./1.7.2.appx.install.webp)

> `.Appx`／`.AppxBundle` 是較舊的相容路徑。若是 Windows Server Core、舊版 Windows 10，或無法按兩下安裝的環境，請參考 [install-manual](https://learn.microsoft.com/windows/wsl/install-manual) 中的手動下載與 `Add-AppxPackage` 說明。

### 7.2. 非官方發行版

非官方發行版或官方清單中沒有的 rootfs，可以透過 tar 檔匯入。tar 可以來自發行版提供的 rootfs，也可以從容器映像匯出：

```
wsl --import <自訂執行個體名稱> <WSL安裝位置> <tar檔案路徑> --version 2
:: 範例：
wsl --import MyDistro E:\wslDistroStorage\MyDistro D:\mywsl\rootfs.tar --version 2
```

> [也可以把容器映像轉成 `.tar` 檔](https://learn.microsoft.com/windows/wsl/use-custom-distro)。透過 `wsl --import` 匯入的 rootfs 通常不會自動建立一般使用者，也不會提供完整的首次啟動體驗；如果想製作成可按兩下安裝、可散佈的 `.wsl` 檔案，需要參考官方 [Build a Custom Linux Distro for WSL](https://learn.microsoft.com/windows/wsl/build-custom-distro)，補齊 `/etc/wsl-distribution.conf` 等中繼資料。

---

## 8. 常用技巧與進階

> 本節記錄一些實用技巧。

### 8.1. 修改預設登入使用者

編輯執行個體內的 `/etc/wsl.conf`，確認其中包含：

```
[user]
default=user1
```

修改後從 Windows 終端機執行以下命令，重新啟動該執行個體：

```powershell
wsl --terminate <執行個體名稱>
wsl -d <執行個體名稱>
```

> 這對透過 `wsl --import` 匯入後預設進入 `root` 的執行個體尤其有用。`/etc/wsl.conf` 是發行版（Linux）內的設定，只影響目前的執行個體；`%UserProfile%\.wslconfig` 是 Windows 主機使用者層級的全域設定，不要混在一起。

### 8.2. 啟用 systemd

目前預設 Ubuntu 發行版可能已經啟用 systemd，先檢查：

```bash
ps -p 1 -o comm=
systemctl status --no-pager
```

若 PID 1 不是 `systemd`，再編輯執行個體內的 `/etc/wsl.conf`，確認其中包含：

```
[boot]
systemd=true
```

接著從 Windows 終端機執行：

```powershell
wsl --shutdown
```

重新進入執行個體後，以 `systemctl status` 確認。systemd [需要 WSL 0.67.6+](https://learn.microsoft.com/windows/wsl/systemd)；若無法使用 `wsl --version` 或版本過舊，先執行 `wsl --update`。

### 8.3. 保持背景執行

先把生命週期分清楚：**systemd 管理服務，不負責讓執行個體保持運作**。`systemctl enable --now ssh` 只是讓 SSH 在 WSL 執行個體啟動後由 systemd 啟動；關閉所有 WSL 終端機後，即使 `ssh.service` 仍顯示 active，發行版執行個體也可能很快被 WSL 判定為閒置並變成 `Stopped`。因此不要為了保持運作而暴露 SSH、Docker、資料庫等服務。

- **優先控制發行版執行個體的閒置回收**：WSL 2.5.4 新增了 `general.instanceIdleTimeout`，用來控制發行版執行個體閒置多久後終止。如果目標是「關閉終端機後仍讓 WSL 執行個體留在背景」，優先在 Windows 主機的 `%UserProfile%\.wslconfig` 中設定：

```ini
[general]
# 單位是毫秒。-1 表示不因執行個體閒置而自動終止
instanceIdleTimeout=-1

[wsl2]
# 控制所有 WSL2 執行個體結束後，底層 WSL2 VM 保留多久
vmIdleTimeout=-1
```

修改後執行：

```powershell
wsl --version
wsl --shutdown
```

> `instanceIdleTimeout` 控制「發行版執行個體」何時停止；`vmIdleTimeout` 控制「承載 WSL2 的底層 VM」何時停止。只修改 `vmIdleTimeout`，可能讓 VM 仍在運作，但特定發行版已經 `Stopped`。`instanceIdleTimeout` 是 `.wslconfig` 中的全域設定，對目前 Windows 使用者下的 WSL2 執行個體生效；目前沒有官方的單一執行個體設定。如果只想讓某一個執行個體保持運作，只能針對該執行個體使用啟動腳本、工作排程器，或下方的舊版相容方案。如果不想永久保留，可把 `-1` 改成明確的毫秒值，例如 `86400000`（24 小時）。這個執行個體層級的設定來自 [WSL 2.5.4 發行說明](https://github.com/microsoft/WSL/releases/tag/2.5.4)；若 `wsl --version` 低於 2.5.4，先執行 `wsl --update`。

- **讓真正的服務隨執行個體啟動**：如果你原本就需要 SSH、Docker、資料庫等背景服務，仍應啟用 systemd，再對特定服務執行 `sudo systemctl enable --now <服務名稱>`。例如：

```bash
sudo systemctl enable --now ssh
```

> 這一步解決的是「執行個體啟動後，服務自動啟動」，不是「執行個體永遠不被回收」。保持運作的事實源仍應是 `.wslconfig` 中的 `instanceIdleTimeout`。

- **舊版相容方案**：若目前 WSL 版本低於 2.5.4，或 `instanceIdleTimeout` 暫時無法在你的環境中使用，再考慮舊文章中的 `dbus-launch` 方案：

```bash
sudo apt install -y dbus-x11
pgrep -u "$(whoami)" -x dbus-daemon >/dev/null || dbus-launch true >/dev/null 2>&1
```

> 這是 workaround，不是清楚的主路徑。也要給它明確的移除條件：升級到支援 `instanceIdleTimeout` 的 WSL 版本，並確認 `wsl -l -v` 不再自動變成 `Stopped` 後，就應刪除這類「假程序保持運作」腳本，避免日後忘記它為何存在。

### 8.4. Windows 啟動時自動啟動 WSL 執行個體

優先讓真正需要的 Linux 服務透過 systemd 自動啟動，例如 SSH：

```bash
sudo systemctl enable --now ssh
```

如果還希望 Windows 使用者登入時主動啟動某個 WSL 執行個體，先依 [8.3. 保持背景執行](#83-保持背景執行) 設定好 `instanceIdleTimeout`，再把以下內容儲存為 `start_wsl_ubuntu.cmd`，放到 `%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` 目錄：

```batch
@echo off
timeout /t 20 /nobreak >nul
wsl.exe -d Ubuntu-24.04 --cd ~ --exec /bin/bash -lc "systemctl is-system-running --wait >/dev/null 2>&1 || true"
```

> 這只負責「登入後啟動執行個體」。若沒有設定 `instanceIdleTimeout`，命令執行完畢後，執行個體仍可能很快因閒置而結束。它也不等同於系統開機服務；若需要在無人登入時啟動，應使用 Windows 工作排程器或專門的服務管理方案。個人開發電腦不要只為了「保持運作」而引入過重的背景服務複雜度。

### 8.5. 啟用與設定 SSH 服務

```bash
# 啟用 SSH 服務（以 Ubuntu 為例）
sudo apt update
sudo apt install -y openssh-server

# 建議使用 systemd 管理
sudo systemctl enable --now ssh
sudo systemctl status ssh --no-pager

# SSH 服務設定檔
sudoedit /etc/ssh/sshd_config
```

依需求調整 `/etc/ssh/sshd_config`：

```text
Port 2222
# 更建議使用金鑰登入。只有本機臨時測試時才考慮改成 yes
PasswordAuthentication no
```

```bash
# 套用修改
sudo systemctl restart ssh
```

如果沒有啟用 systemd，可使用 `sudo service ssh restart`。Windows 本機可用以下命令連線：

```powershell
ssh -p 2222 <Linux使用者名稱>@localhost
```

> 若要從區域網路其他裝置存取 WSL 中的 SSH，還需要配合 [6. WSL2 底層原理與網路設定](#6-wsl2-底層原理與網路設定) 開放連接埠與防火牆。

### 8.6. 存取 Windows 主機檔案系統

WSL 執行個體會自動掛載 Windows 主機的磁碟機，包括 C 槽、D 槽等：

```
ls -l  /mnt/c
ls -l  /mnt/d
```

也可以從 WSL 呼叫 Windows 程式：

```bash
explorer.exe .
notepad.exe /mnt/c/Temp/test.txt
```

> `/mnt/c`、`/mnt/d` 很適合偶爾讀寫 Windows 檔案，但不適合存放 Linux 工具鏈頻繁讀寫的專案目錄；效能提醒請見 [8.9. 檔案系統效能提醒](#89-檔案系統效能提醒)。

### 8.7. 取得 Windows 主機的環境變數

```bash
# 單次讀取 Windows 環境變數 %USERPROFILE%
MY_ENV_VAR=$(cmd.exe /c echo %USERPROFILE% | tr -d '\r')
echo "MY_ENV_VAR in WSL: $MY_ENV_VAR"
```

若需要長期在 Windows 與 WSL 之間共享變數，優先了解 [`WSLENV`](https://learn.microsoft.com/windows/wsl/filesystems#share-environment-variables-between-windows-and-wsl-with-wslenv)。它可以宣告哪些變數要在兩邊互通，並處理路徑格式轉換。

### 8.8. 從 Windows 主機存取 WSL 執行個體檔案系統

```
:: 從檔案總管直接存取：
\\wsl.localhost\
:: 舊寫法通常也可用：
\\wsl$\
:: 在桌面建立捷徑：
mklink /D "%userprofile%\Desktop\wsl_home" "\\wsl.localhost\"
:: 對應為本機 H 槽：
net use H: \\wsl.localhost\Ubuntu-24.04\home /persistent:yes
:: 取消對應：
net use H: /delete

:: 或者從 WSL 執行個體中執行：
:: 用 Windows 主機的檔案總管開啟目前目錄
explorer.exe  .
:: 用 Windows 主機的 VS Code 或 Cursor 開啟目前目錄
code .
```

### 8.9. 檔案系統效能提醒

在 WSL2 執行個體中存取 Windows 主機檔案系統雖然方便，但頻繁的小檔案讀寫效能通常不如 Linux 檔案系統內的路徑。可以用以下原則判斷：

- 主要由 Linux 工具鏈處理的專案，放在 `/home/<user>/...`。
- 主要由 Windows 工具鏈處理的專案，放在 `C:\...`／`D:\...`。
- 如果必須長期從 Linux 頻繁存取 Windows 檔案系統，可以評估 WSL1 是否更適合這個特定情境。

參考：[Working across Windows and Linux file systems](https://learn.microsoft.com/windows/wsl/filesystems)、[WSL1 與 WSL2 的差異](https://learn.microsoft.com/windows/wsl/compare-versions#exceptions-for-using-wsl-1-rather-than-wsl-2)、[GitHub issue](https://github.com/microsoft/WSL/issues/9555)

### 8.10. 安裝多個執行個體

請參考 [5.2. 備份](#52-備份) 與 [5.3. 還原或新增執行個體](#53-還原或新增執行個體)。
透過 `wsl --import` 命令，可以從同一個 `.tar` 備份映像建立任意多個執行個體；若是官方 `.wsl` 發行套件，也可參考 [7.1. 離線安裝官方發行版](#71-離線安裝官方發行版)，使用 `wsl --install --from-file` 安裝。

### 8.11. 免密碼 sudo

如果這是個人本機開發環境，而且你明確想減少重複輸入密碼的摩擦，可以為目前 Linux 使用者啟用免密碼 sudo。先從 Windows 終端機進入目標執行個體：

```powershell
wsl -d <執行個體名稱> -u <需要sudo的Linux使用者>
```

接著在 WSL 內執行：

```bash
printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$USER" | sudo tee "/etc/sudoers.d/$USER" >/dev/null
sudo chmod 0440 "/etc/sudoers.d/$USER"
sudo visudo -cf "/etc/sudoers.d/$USER" && sudo -l
```

> 免密碼 sudo 會降低誤操作的門檻，適合個人本機開發環境。

> 以上是從 WSL 安裝、備份、遷移、網路到常用技巧的整理。若希望把背景保持運作、備份／還原、遷移、SSH、systemd 與連接埠開放收進一個執行個體命令，可參考 [SWAW Kit WSL 一鍵管理工具](/zh-tw/p/swaw-kit-wsl-release/)。

> 微信技術交流群：
> {{< asset src="site/brand/wecom-ex-group-ai-cockpit.gif" alt="企業微信外部群組「AI 駕駛艙」QR Code" >}}
