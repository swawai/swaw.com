---
title: 標籤
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
  mode: tree
  show_in_home: true
  home_weight: 30
  article_weight: 30
  normalize: lower
  article_mode: deepest_by_root
  term_rel: tag
  unassigned_term: untagged
  unassigned_label: --untagged--
---

在 Banyan 裡，`tags` 仍然是輔助維度。

它更適合表達主題路徑和補充關鍵詞，而不是取代 `intent`。

{{< taxonomy-list >}}
