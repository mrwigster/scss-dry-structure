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

## BTT2021 Theme Snapshot

This snapshot is based on the `btt2021` theme structure:

- Primary SCSS root: `sass/`
- Main entrypoint: `sass/style.scss`
- Bespoke layer entrypoint: `sass/btt/_styles.scss` (imported from `sass/style.scss`)
- Global variables: `sass/abstracts/variables/`
- Project variables: `sass/btt/_vars.scss`
- Global mixins: `sass/abstracts/mixins/_mixins.scss`
- Responsive mixins: `sass/btt/_mediaq.scss` (`desktop`, `wide`, `lessThanDesktop`, `tablet`, `lessThanTablet`, `mobile`)
- Common custom naming style: kebab-case component classes with nested child selectors
- BEM-like selectors mostly appear in WordPress/WooCommerce/plugin classes (for example `woocommerce-cart-form__cart-item`, `select2-selection--single`)

## Useful Checks

```bash
rg -n '^\$[a-zA-Z0-9_-]+\s*:' sass -g '*.scss'
rg -n '^\s*@mixin\s+[a-zA-Z0-9_-]+' sass -g '*.scss'
rg -n '@include\s+[a-zA-Z0-9_-]+' sass -g '*.scss'
rg -o '\.[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*(?:__(?:[a-zA-Z0-9-]+)|--(?:[a-zA-Z0-9-]+))' sass -g '*.scss' | sort -u
```
