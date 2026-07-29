---
date: "2026-06-23T08:30:00+08:00"
draft: false
title: "WSL Toolkit: One-Command Keep-Alive, Backups, SSH, systemd, and Port Forwarding"
linkTitle: "One-Command WSL Toolkit"
slug: "swaw-kit-wsl-release"
description: "Bind one command script to each WSL instance for keep-alive, backups, restores, migration, SSH, systemd, and port forwarding—usable by people and AI agents."
share_image: swaw-kit-wsl-release-en-share.png
nav_primary: signals
intent:
 - explore
tags:
 - tooling/devtools/windows
---





![SWAW Kit one-command-per-WSL-instance article cover](swaw-kit-wsl-en-cover.png)


WSL on Windows keeps getting better. But if you use it as your everyday Linux environment, you will probably still run into these problems:

1. WSL 2 shuts down when it has no active tasks. I assumed that enabling systemd to manage `sshd` would be enough, but the instance still stops.
2. A service is running inside WSL, yet your phone or another computer cannot reach it. You still need to configure port forwarding and firewall access.
3. Want SSH? That means a whole combo: enable systemd, install `sshd`, change the default port, and perhaps configure a public key.
4. Important data accumulates over time, but nobody remembers the commands for infrequent operations such as backup, restore, and migration.
5. Once you have several instances, the same setup work keeps repeating.


This is how I handle it now:

```cmd
wsl02 .alive
wsl02 .sshd enable 2228
wsl02 .port expose 2228 2228 --uac
```

After those three commands:

```
✅ WSL stays running even when idle
✅ SSH and systemd are ready in one step (restart the WSL virtual machine once if needed; details follow)
✅ The port is forwarded and allowed through the firewall for LAN access
```

Backup and restore are just as direct:

```
wsl02 .backup
wsl02 .install D:\backup\xxx.tar --yes
```

Not bad, right?


## 1. The toolkit is open source and takes three steps

1. Clone it:

```cmd
git clone https://github.com/swawai/swaw-kit
```

2. Copy the template:

```
cd swaw-kit
copy .\Favorites\template.wsl01.cmd .\wsl02.cmd
```

Open `wsl02.cmd` in a text editor and set the instance name, username, and installation image source, such as Ubuntu or Debian.

3. Install the instance:

```cmd
wsl02 .install
```

If installation fails, run the diagnostic command and take its output to an AI assistant:

```cmd
wsl02 .doctor
```

Once installation finishes, run `wsl02` to enter the bound instance:

![Run wsl02 directly in Windows Terminal to enter the bound WSL instance](wsl02-enter-after-install.png)

4. That is it.

All the one-command features are now available. For example, keep-alive:

```cmd
:: Keep the instance alive for 3600 seconds:
wsl02 .alive 3600
:: Disable the keep-alive policy:
wsl02 .alive off
```

Manage backup, restore, migration, and reinstallation in the same way. The relevant paths are defined in `wsl02.cmd`:

```cmd
:: Create a backup:
wsl02 .backup
:: List existing backup files:
wsl02 .backup list
:: Restore by reinstalling from a backup. All data in the current WSL instance will be lost.
:: --yes is required to confirm the overwrite:
wsl02 .install D:\backup\xxx.tar --yes
:: ...
```

Manage systemd:

```cmd
:: Enable systemd:
wsl02 .systemd enable
:: A systemd configuration change does not take effect immediately.
:: Restart the underlying WSL 2 virtual machine. All WSL instances for the current user
:: will shut down briefly:
wsl02 .vm -s
:: Disable systemd:
wsl02 .systemd disable
```

The toolkit also manages the SSH service, port forwarding, and more without making you memorize every subcommand.

Just run `--help`, and a love letter to WSL unfolds:

```cmd
wsl02 --help
```

The output is grouped by module and easy to scan.



## 2. What it looks like



Create a backup:

```cmd
wsl02 .backup
```

![wsl02 .backup finishes exporting a WSL instance to a tar archive](wsl02-backup-export-tar.png)


Restore an instance by reinstalling it from a selected backup:

```cmd
wsl02 .install D:\backup\Backup_wsl02_20260617083000.tar --yes
```

![wsl02 .install reinstalls and restores a WSL instance from a backup archive](wsl02-restore-from-backup-archive.png)


Inspect the port policy:

```cmd
wsl02 .port status
```

![wsl02 .port status shows the Hyper-V firewall port policy for mirrored networking](wsl02-hyperv-firewall-port-rule.png)

Log in over SSH:

![Log in to the WSL instance over SSH after enabling keep-alive and setting the wsl02 user password](wsl02-alive-passwd-ssh-login.png)





## 3. Multiple instances and AI agent support

With one WSL instance, this toolkit is convenient. With three or more, it can be a lifesaver.

Copy the `wsl02` pattern to create `wsl03`, `wsl04`, `wsl05`, and so on, binding one command to each WSL instance. From there, it feels like the accelerator has been welded to the floor:

```cmd
:: Install:
wsl03 .install
wsl04 .install
wsl05 .install
:: Back up:
wsl03 .backup
:: Reinstall:
wsl04 .install --yes
:: Keep alive:
wsl04 .alive
:: Open a WSL directory in VS Code:
wsl05 .code ~/myproj/
:: Enable SSH:
wsl05 .sshd enable 2228
:: ...

:: Too many commands to remember? Run --help:
wsl03 --help
wsl04 --help
wsl05 --help
```

Even if you have a pile of WSL instances, thoughtful names keep them orderly:

```cmd
:: Name by group and number:
group1-wsl1.cmd
group1-wsl2.cmd

:: Name by purpose:
website-test.cmd
claude-code.cmd
openclaw.cmd
agent-lab.cmd
research-box.cmd
sandbox.cmd
```

The more WSL instances you manage, the more valuable this one-command-script-per-instance model becomes. A fixed entry point also helps AI agents:

```text
- The command name identifies the target instance, so boundaries stay clear
- Keep-alive, backups, SSH, and port management use stable one-command subcommands
- Core commands remain non-interactive
- Destructive operations explicitly require --yes
- Administrator operations explicitly require --uac
- .status and .doctor support JSON output
```



I asked Codex to try it. Its verdict was that the design **significantly improves agent reliability, saves a small number of command-entry tokens, and produces moderate to significant savings in diagnostic and exploration tokens**. The screenshot below captures that feedback. I have since addressed its minor suggestions and abuse cases:

![Codex evaluates the agent-friendly one-instance-one-entry design of SWAW Kit WSL](codex-agent-feedback-swaw-kit-wsl.png)




## 4. Add the toolkit to PATH

Want commands such as `wsl02` and `wsl03` to run from any terminal or from `Win + R`? Double-click this file in the repository:

```cmd
PathHereAdd.cmd
```

That is all.

How do you undo it afterward? Is modifying PATH safe? See [Run Custom Commands from Win + R](/zh/p/win-run-custom-command-path/). The linked translation is still in progress, so this link currently opens the Simplified Chinese article.





---



> Source repository—Issues and pull requests are welcome: [https://github.com/swawai/swaw-kit](https://github.com/swawai/swaw-kit)
