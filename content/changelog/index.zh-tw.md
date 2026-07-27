---
title: "更新記錄"
description: "查看 Swaw 目前部署版本、原始碼修訂與可用的發布資訊。"
slug: "changelog"
type: "page"
layout: "article-page"
changelog:
  intro: "Swaw 的自動更新記錄，展示目前部署版本、構建時間和可用的原始碼資訊。"
  current_build: "目前構建"
  build_version: "構建版本"
  build_time: "構建時間"
  git_commit: "Git 提交"
  page_source_revision: "頁面來源提交"
  theme_source: "主題原始碼"
  theme_repo: "https://github.com/swawai/banyan"
  release_notes: "發布說明"
  release_notes_fallback: "詳細發布說明仍在整理；目前先保留可驗證的部署版本與來源資訊。"
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  footer: /fragments/home-footer-shortcuts
build:
  list: "never"
---

{{< changelog-fallback >}}
