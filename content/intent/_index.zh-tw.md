---
title: 閱讀目的
browser_title: "閱讀目的：探索與決策"
description: "按閱讀目的瀏覽文章：探索想法、評估方案並輔助決策。"
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
