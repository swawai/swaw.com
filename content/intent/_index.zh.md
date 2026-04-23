---
title: 意图
nav_primary: signals
layout: article
slots:
  primary_nav: /fragments/nav-primary-links
  utilities: /fragments/nav-utilities
  breadcrumb: /fragments/breadcrumb-signals
cascade:
  - _target:
      kind: term
    nav_primary: signals
    layout: article
    slots:
      primary_nav: /fragments/nav-primary-links
      utilities: /fragments/nav-utilities
      breadcrumb: /fragments/breadcrumb-signals
banyan_taxonomy:
  mode: flat
  show_in_home: true
  home_weight: 20
  article_weight: 20
  normalize: lower
  article_mode: all
---

`intent` 和 `tags` 回答的不是同一个问题：

- `tags` 负责描述“这篇关于什么”
- `intent` 负责描述“作者为什么写这篇，希望它推动读者完成什么认知动作”

{{< taxonomy-list >}}
