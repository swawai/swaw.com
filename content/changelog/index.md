---
title: "Changelog"
description: "Review the currently deployed Swaw build, source revision, and available release information."
slug: "changelog"
type: "page"
layout: "article-page"
changelog:
  intro: "Swaw's automatic changelog shows the currently deployed build, build time, and available source information."
  current_build: "Current build"
  build_version: "Build version"
  build_time: "Build time"
  git_commit: "Git commit"
  page_source_revision: "Page source commit"
  theme_source: "Theme source"
  theme_repo: "https://github.com/swawai/banyan"
  release_notes: "Release notes"
  release_notes_fallback: "Detailed release notes are still being organized. For now, this page keeps the deployed build and its source information verifiable."
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  footer: /fragments/home-footer-shortcuts
build:
  list: "never"
---

{{< changelog-fallback >}}
