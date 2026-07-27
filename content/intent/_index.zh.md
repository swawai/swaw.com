---
title: 阅读目的
browser_title: "阅读目的：探索与决策"
description: "按阅读目的浏览文章：探索想法、评估方案并辅助决策。"
nav_primary: signals
layout: article-list
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  breadcrumb_root: /fragments/breadcrumb-model-signals
  breadcrumb: true
cascade:
  - _target:
      kind: term
    nav_primary: signals
    layout: article-list
    slots:
      primary_nav: /fragments/nav-primary-links
      utilities: /fragments/nav-utilities
      breadcrumb_root: /fragments/breadcrumb-model-signals
      breadcrumb: true
banyan_taxonomy:
  mode: flat
  show_in_home: true
  home_weight: 20
  article_weight: 20
  normalize: lower
  article_mode: all
---


{{< taxonomy-list >}}
