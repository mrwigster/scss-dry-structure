# scss-dry-structure

A Codex skill for SCSS-first, DRY styling workflows.

Use this skill when adding or modifying styles so Codex:

- follows your existing Sass file structure
- reuses existing variables/mixins before creating new ones
- keeps nesting maintainable
- matches local naming patterns (including BEM where present)

## Install

### Install via skill-installer

```bash
$skill-installer install https://github.com/mrwigster/scss-dry-structure/tree/main
```

### Manual install

```bash
git clone https://github.com/mrwigster/scss-dry-structure.git ~/.codex/skills/scss-dry-structure
```

## Quick Start

From a project root:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
"$CODEX_HOME/skills/scss-dry-structure/scripts/scss_audit.sh" sass
```

Then implement style changes using rules in `SKILL.md`.

## Example Prompts

- "Refactor this CSS block into existing SCSS partials and reuse current variables/mixins."
- "Add responsive styles for the card component without introducing duplicate breakpoints."
- "Find if this selector already exists and apply changes in the correct partial."
- "Audit this theme's SCSS structure and suggest the right file placement for a new feature."
- "Rewrite these repeated declarations into a reusable mixin and update includes."

## Repository Layout

- `SKILL.md`: main skill instructions and workflow
- `scripts/scss_audit.sh`: automated SCSS structure/pattern audit
- `references/scss-patterns.md`: architecture and naming guardrails
- `agents/openai.yaml`: UI metadata
