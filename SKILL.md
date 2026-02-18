---
name: scss-dry-structure
description: Enforce SCSS-first, DRY styling changes in existing codebases. Use when adding or modifying CSS/SCSS so Codex follows the current Sass file structure, reuses existing tokens and mixins, preserves cascade-layer placement, keeps nesting maintainable, and aligns with established selector conventions such as BEM or kebab-case naming.
---

# SCSS DRY Structure

Implement style changes by extending the existing SCSS architecture instead of adding isolated CSS overrides.
Treat structure discovery and token reuse as required steps.

## Required Preflight

1. Detect the SCSS root and audit conventions before writing style code.

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
"$CODEX_HOME/skills/scss-dry-structure/scripts/scss_audit.sh"
```

The audit script auto-detects common roots (for example `sass/`, `scss/`, `public/assets/scss/`).
If detection is wrong or ambiguous, pass the root path explicitly.

2. Search for existing selectors and tokens in the local target area.

```bash
rg -n "<selector|component|feature-keyword>" <scss-root> -g '*.scss'
rg -n '^\$[a-zA-Z0-9_-]+\s*:' <scss-root> -g '*.scss'
rg -n '^[[:space:]]*--[a-zA-Z0-9_-]+\s*:' <scss-root> -g '*.scss'
rg -n 'var\(--[a-zA-Z0-9_-]+\)' <scss-root> -g '*.scss'
rg -n '^\s*@mixin\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
rg -n '@include\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
rg -n '^[[:space:]]*@layer\b' <scss-root> -g '*.scss'
```

3. Choose placement before authoring declarations.
- Reuse an existing partial when scope matches.
- Create a new partial only when no suitable file exists.
- Wire new partials into the nearest aggregator file (`@import`, `@use`, or `@forward` pattern already in use).
- If the project uses cascade layers, place imports/rules in the correct existing `@layer` block.

## Authoring Rules (DRY-First)

- Reuse existing variables, mixins, placeholders, and utility classes before introducing new ones.
- Reuse existing CSS custom properties (`--token` + `var(--token)`) before adding new literal values.
- Introduce a new variable or mixin only after search proves there is no suitable existing token.
- If token architecture is custom-property-first, add new tokens there rather than introducing ad-hoc Sass variables.
- Prefer extracting repeated declaration sets into a mixin/placeholder instead of copy-paste selectors.
- Keep nesting shallow (target three levels or fewer).
- Use `&` for modifier/state/pseudo usage (`&:hover`, `&--active`, `&__title`) rather than long descendant chains.
- Preserve established cascade layer order. Do not move rules across layers unless required by specificity intent.
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
- `tokens/` or root token partials: CSS custom properties and design tokens.
- `base/`: raw elements and global defaults.
- `layouts/`: structural page/layout rules.
- `components/`: reusable UI blocks.
- `plugins/` or integration folders: third-party overrides.
- `theme/`, `custom/`, or equivalent brand layer: bespoke project-specific styling.

## Completion Checklist

- Confirm target rule lives in the correct partial.
- Confirm no equivalent variable/mixin already exists.
- Confirm no equivalent CSS custom property token already exists.
- Confirm new partial imports are wired correctly.
- Confirm layer placement is correct when `@layer` is present.
- Confirm nesting depth stays maintainable.
- Confirm naming matches local conventions (BEM/kebab/plugin-specific).
- Run project lint/build command when available.
- Rebuild generated CSS outputs when the project tracks compiled artifacts.

## References

- Practical architecture and pattern notes: `references/scss-patterns.md`
- Automated repository scan: `scripts/scss_audit.sh`
