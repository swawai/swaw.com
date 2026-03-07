# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Created a centralized `CHANGELOG.md` to track project evolution and technical decisions.

### Changed
- **SEO Defense System (High Priority)**: Implemented robust Canonical Links and custom Sitemap generation to protect the multi-dimensional static sorting system from SEO penalties.
  - *Context*: The use of multiple `[outputFormats]` (like `byname`, `bycount`) created an exponential explosion of duplicate list pages.
  - *Sitemap Optimization*: A custom `layouts/sitemap.xml` was added to the `banyan` theme. It actively filters out all custom sorting outputs, ensuring only the pure, default `bydate` paths are submitted to search engines.
  - *Canonical Link Enforcement*: Modified `themes/banyan/layouts/_default/baseof.html` to dynamically calculate and injecting a canonical link pointing strictly back to the root node's `bydate` format, effectively preventing Duplicate Content penalties and consolidating link equity across all sorting variations.
  - *Canonical Pagination Compatibility*: Enhanced the canonical link logic in `baseof.html` to accurately intercept and correctly transfer deep pagination suffixes (`/page/2/`, etc.) from sorting variation URLs directly onto the default pure Canonical target. This comprehensively safeguards the site against the "indexation blackhole" problem associated with deep-linking pagination.
