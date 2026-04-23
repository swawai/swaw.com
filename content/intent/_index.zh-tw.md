---
title: 意圖
nav_primary: signals
layout: article
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  breadcrumb_root: /fragments/breadcrumb-model-signals
  breadcrumb: true
cascade:
  - _target:
      kind: term
    nav_primary: signals
    layout: article
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

`intent` 和 `tags` 回答的不是同一個問題：

- `tags` 負責描述「這篇關於什麼」
- `intent` 負責描述「作者為什麼寫這篇，希望它推動讀者完成什麼認知動作」

{{< taxonomy-list >}}
