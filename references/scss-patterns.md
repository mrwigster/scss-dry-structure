# SCSS Pattern Reference

Use this reference after running `scripts/scss_audit.sh` to decide placement and naming quickly.

## DRY Reuse Priority

1. Reuse an existing selector block in the same module.
2. Reuse an existing variable token.
3. Reuse an existing mixin or placeholder.
4. Create a new token only when there is no safe match.

## Nesting Guardrails

- Keep nesting shallow (target three levels or fewer).
- Prefer component class hooks over long descendant chains.
- Use `&` for state/modifier forms (`&:hover`, `&--active`, `&__title`).

## Naming Guardrails

- Follow the dominant local style in the touched file.
- Use BEM (`block__element--modifier`) only where BEM is already part of that module.
- Keep third-party selectors unchanged and wrap custom logic around them.

## Typical WordPress SCSS Snapshot

Use this as a default map when a project follows a partial-based Sass architecture:

- Primary SCSS root: `sass/` or `scss/`
- Main entrypoint: `sass/style.scss` or `scss/main.scss`
- Global variables: `abstracts/variables/` (or similarly named token folder)
- Global mixins: `abstracts/mixins/` (or similarly named utilities folder)
- Responsive mixins often live in a dedicated partial such as `_mediaq.scss`, `_breakpoints.scss`, or `mixins/_responsive.scss`
- Project-specific overrides commonly live in dedicated folders like `theme/`, `custom/`, or `brand/`
- Common custom naming style is often kebab-case component classes with nested child selectors
- BEM-like selectors often appear in plugin/framework markup classes (for example `__` and `--` forms)

## Useful Checks

```bash
rg -n '^\$[a-zA-Z0-9_-]+\s*:' sass -g '*.scss'
rg -n '^\s*@mixin\s+[a-zA-Z0-9_-]+' sass -g '*.scss'
rg -n '@include\s+[a-zA-Z0-9_-]+' sass -g '*.scss'
rg -o '\.[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*(?:__(?:[a-zA-Z0-9-]+)|--(?:[a-zA-Z0-9-]+))' sass -g '*.scss' | sort -u
```
