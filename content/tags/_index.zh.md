---
title: 标签
layout: article
cascade:
  - _target:
      kind: term
    layout: article
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

在 Banyan 里，`tags` 仍然是辅助维度。

它更适合表达主题路径和补充关键词，而不是替代 `intent`。

{{< taxonomy-list >}}
