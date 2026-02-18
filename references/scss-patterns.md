# SCSS Pattern Reference

Use this reference after running `scripts/scss_audit.sh` to decide placement and naming quickly.

## DRY Reuse Priority

1. Reuse an existing selector block in the same module.
2. Reuse an existing CSS custom property token (`var(--token)`) where the project is tokenized this way.
3. Reuse an existing Sass variable token where Sass variables are already the dominant pattern.
4. Reuse an existing mixin or placeholder.
5. Create a new token only when there is no safe match.

## Nesting Guardrails

- Keep nesting shallow (target three levels or fewer).
- Prefer component class hooks over long descendant chains.
- Use `&` for state/modifier forms (`&:hover`, `&--active`, `&__title`).

## Cascade Layer Guardrails

- Keep existing `@layer` order unchanged.
- Add new imports/rules inside the nearest matching existing layer.
- Do not move selectors across layers unless intentional precedence changes are required.

## Naming Guardrails

- Follow the dominant local style in the touched file.
- Use BEM (`block__element--modifier`) only where BEM is already part of that module.
- Keep third-party selectors unchanged and wrap custom logic around them.

## Common Architecture Profiles

Use the profile that best matches what the audit found.

### Profile A: Legacy partial stack (`@import`)

- Root often looks like `sass/`, `scss/`, `public/assets/scss/`, or `assets/scss/`.
- Entrypoints are non-partials (`style.scss`, `main.scss`, `app.scss`).
- Partials are underscore-prefixed and grouped by concern (`components/`, `base/`, `layout/`, `tools/`).
- Placement decisions are mostly about selecting the right partial and aggregator import location.

### Profile B: Module system (`@use` + `@forward`)

- Tokens/mixins are often centralized in `abstracts/` or `foundation/`.
- Components typically import modules with namespace prefixes.
- Placement decisions include namespace consistency and avoiding duplicate forwards.

### Profile C: Layered architecture (`@layer`)

- Entrypoint declares named layer order (for example `tokens`, `base`, `components`, `utilities`).
- Feature partials are imported inside layer blocks.
- Placement decisions must preserve layer order and intended precedence.

## Token Architecture Signals

- Custom-property-first systems have many `--token` definitions and frequent `var(--token)` usage.
- Sass-variable-first systems have many `$token` definitions reused across partials.
- Mixed systems are common: keep compile-time concerns in Sass variables and runtime/theming concerns in CSS custom properties.

## Useful Checks

```bash
rg -n '^\$[a-zA-Z0-9_-]+\s*:' <scss-root> -g '*.scss'
rg -n '^[[:space:]]*--[a-zA-Z0-9_-]+\s*:' <scss-root> -g '*.scss'
rg -n 'var\(--[a-zA-Z0-9_-]+\)' <scss-root> -g '*.scss'
rg -n '^\s*@mixin\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
rg -n '@include\s+[a-zA-Z0-9_-]+' <scss-root> -g '*.scss'
rg -n '^[[:space:]]*@layer\b' <scss-root> -g '*.scss'
rg -o '\.[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*(?:__(?:[a-zA-Z0-9-]+)|--(?:[a-zA-Z0-9-]+))' <scss-root> -g '*.scss' | sort -u
```
