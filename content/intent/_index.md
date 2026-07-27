---
title: Reading Goals
browser_title: "Reading Goals: Explore and Decide"
description: "Browse articles by reading goal: explore ideas, evaluate options, and make decisions."
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
