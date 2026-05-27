---
date: "2026-05-28T00:37:56+08:00"
draft: false
title: "ssh -R: a temporary proxy bridge for dependency downloads"
slug: "ssh-reverse-port-forward-proxy"
description: "This article is currently available in Simplified Chinese. It explains how to use SSH remote port forwarding to let a server temporarily borrow your local HTTP proxy for dependency downloads."
nav_primary: signals
build:
  list: never
---

# ssh -R: let a server temporarily borrow your local proxy for dependency downloads

This article is currently available in Simplified Chinese.

It explains how to use SSH remote port forwarding to map a server-local proxy port to your workstation's HTTP proxy, so npm, pip, GitHub release downloads, and similar dependency fetches can get unstuck during deployment.

[Read the Simplified Chinese version](/zh/p/ssh-reverse-port-forward-proxy/)
