---
name: scss-dry-structure
description: Enforce SCSS-first, DRY styling changes in existing codebases. Use when adding or modifying CSS/SCSS so Codex follows the current Sass file structure, reuses existing variables and mixins, keeps nesting maintainable, and aligns with established selector conventions such as BEM or kebab-case naming.
---

# SCSS DRY Structure

Implement style changes by extending the existing SCSS architecture instead of adding isolated CSS overrides.
Treat structure discovery and token reuse as required steps.

## Required Preflight

1. Detect the SCSS root and audit conventions before writing style code.

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
"$CODEX_HOME/skills/scss-dry-structure/scripts/scss_audit.sh" sass
```

If `sass` is not the root folder, pass the correct path.

2. Search for existing selectors and tokens in the local target area.

```bash
rg -n "<selector|component|feature-keyword>" <scss-root> -g '*.scss'
rg -n '^\$[a-zA-Z0-9_-]+\s*:' <scss-root> -g '*.scss'
rg -n '^\s*@mixin\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
rg -n '@include\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
```

3. Choose placement before authoring declarations.
- Reuse an existing partial when scope matches.
- Create a new partial only when no suitable file exists.
- Wire new partials into the nearest aggregator file (`@import`, `@use`, or `@forward` pattern already in use).

## Authoring Rules (DRY-First)

- Reuse existing variables, mixins, placeholders, and utility classes before introducing new ones.
- Introduce a new variable or mixin only after search proves there is no suitable existing token.
- Prefer extracting repeated declaration sets into a mixin/placeholder instead of copy-paste selectors.
- Keep nesting shallow (target three levels or fewer).
- Use `&` for modifier/state/pseudo usage (`&:hover`, `&--active`, `&__title`) rather than long descendant chains.
- Avoid adding styles directly into compiled CSS outputs when source partials exist.

## Naming And Structure Matching

- Detect the dominant selector style in nearby files first.
- Continue existing naming in the same module:
  - BEM modules: `block__element--modifier`.
  - Hyphenated modules: `feature-card`, `feature-card-title`, etc.
- Preserve external plugin selector names exactly (for example WooCommerce classes) and layer custom classes around them.
- Match existing import system in that code path (`@import` legacy stacks vs `@use` module stacks).

## File Placement Guide

- `abstracts/` or similar: tokens (variables/mixins/functions/placeholders).
- `base/`: raw elements and global defaults.
- `layouts/`: structural page/layout rules.
- `components/`: reusable UI blocks.
- `plugins/` or integration folders: third-party overrides.
- `theme/`, `custom/`, or equivalent brand layer: bespoke project-specific styling.

## Completion Checklist

- Confirm target rule lives in the correct partial.
- Confirm no equivalent variable/mixin already exists.
- Confirm new partial imports are wired correctly.
- Confirm nesting depth stays maintainable.
- Confirm naming matches local conventions (BEM/kebab/plugin-specific).
- Run project lint/build command when available.

## References

- Practical architecture and pattern notes: `references/scss-patterns.md`
- Automated repository scan: `scripts/scss_audit.sh`
