---
title: "更新记录"
description: "查看 Swaw 当前部署版本、源码修订与可用的发布信息。"
slug: "changelog"
type: "page"
layout: "article-page"
changelog:
  intro: "Swaw 的自动更新记录，展示当前部署版本、构建时间和可用的源码信息。"
  current_build: "当前构建"
  build_version: "构建版本"
  build_time: "构建时间"
  git_commit: "Git 提交"
  page_source_revision: "页面来源提交"
  theme_source: "主题源码"
  theme_repo: "https://github.com/swawai/banyan"
  release_notes: "发布说明"
  release_notes_fallback: "详细发布说明仍在整理；当前先保留可验证的部署版本与来源信息。"
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  footer: /fragments/home-footer-shortcuts
build:
  list: "never"
---

{{< changelog-fallback >}}
