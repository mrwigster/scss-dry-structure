#!/usr/bin/env bash

set -euo pipefail

requested_root="${1:-}"
root=""
auto_detected_roots=(
  sass
  scss
  styles
  assets/scss
  public/assets/scss
  resources/scss
  src/sass
  src/scss
  src/styles
  app/assets/scss
  web/assets/scss
)

if [ -n "$requested_root" ]; then
  if [ -d "$requested_root" ]; then
    root="$requested_root"
  else
    echo "Requested SCSS root does not exist: $requested_root"
    echo "Run without arguments for auto-detection, or pass a valid path."
    exit 1
  fi
else
  for candidate in "${auto_detected_roots[@]}"; do
    if [ -d "$candidate" ]; then
      root="$candidate"
      break
    fi
  done
fi

if [ -z "$root" ]; then
  echo "No SCSS root folder found."
  echo "Auto-detection checked: ${auto_detected_roots[*]}"
  echo "Run: scss_audit.sh <scss-root>"
  exit 1
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required for this audit script."
  exit 1
fi

scss_files="$(rg --files "$root" -g '*.scss' | sort)"

if [ -z "$scss_files" ]; then
  echo "No .scss files found under: $root"
  exit 0
fi

file_count="$(printf '%s\n' "$scss_files" | sed '/^$/d' | wc -l | tr -d ' ')"

echo "SCSS root: $root"
echo "Total .scss files: $file_count"
echo

echo "Entrypoint files (non-partials):"
printf '%s\n' "$scss_files" | awk -F/ 'substr($NF,1,1)!="_"{print "  - "$0}'
echo

echo "Partial files (sample):"
printf '%s\n' "$scss_files" | awk -F/ 'substr($NF,1,1)=="_"{print "  - "$0}' | head -n 20
echo

echo "Import/use/forward statements (sample):"
rg -n "^[[:space:]]*@(import|use|forward)[[:space:]]+" "$root" -g '*.scss' | head -n 80 || true
echo

echo "Layer declarations/usages (sample):"
rg -n "^[[:space:]]*@layer([[:space:]]|$)" "$root" -g '*.scss' | head -n 80 || true
echo

echo "Defined mixins:"
mixins="$(rg --no-filename -o "^[[:space:]]*@mixin[[:space:]]+[a-zA-Z0-9_-]+" "$root" -g '*.scss' | sed -E 's/^[[:space:]]*@mixin[[:space:]]+//' | sort -u || true)"
if [ -n "$mixins" ]; then
  printf '%s\n' "$mixins" | sed 's/^/  - /'
else
  echo "  (none found)"
fi
echo

echo "Most-used includes:"
includes="$(rg --no-filename -o "@include[[:space:]]+[a-zA-Z0-9_-]+" "$root" -g '*.scss' | sed -E 's/@include[[:space:]]+//' | sort | uniq -c | sort -nr | head -n 20 || true)"
if [ -n "$includes" ]; then
  printf '%s\n' "$includes" | sed 's/^/  /'
else
  echo "  (none found)"
fi
echo

echo "Defined Sass variables (sample):"
rg -n '^[[:space:]]*\$[a-zA-Z0-9_-]+[[:space:]]*:[[:space:]]*(\(|.*;)[[:space:]]*(//.*)?$' "$root" -g '*.scss' | head -n 120 || true
echo

echo "Defined CSS custom properties (sample):"
rg -n '^[[:space:]]*--[a-zA-Z0-9_-]+[[:space:]]*:' "$root" -g '*.scss' | head -n 120 || true
echo

echo "Most-used CSS custom properties:"
css_var_usage="$(rg --no-filename -o "var\\(--[a-zA-Z0-9_-]+\\)" "$root" -g '*.scss' | sed -E 's/^var\(--([^)]+)\)$/\1/' | sort | uniq -c | sort -nr | head -n 20 || true)"
if [ -n "$css_var_usage" ]; then
  printf '%s\n' "$css_var_usage" | sed 's/^/  /'
else
  echo "  (none found)"
fi
echo

echo "BEM-style selectors (sample):"
bem="$(rg --no-filename -o "\\.[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*(?:__(?:[a-zA-Z0-9-]+)|--(?:[a-zA-Z0-9-]+))" "$root" -g '*.scss' | sort -u | head -n 80 || true)"
if [ -n "$bem" ]; then
  printf '%s\n' "$bem" | sed 's/^/  - /'
else
  echo "  (none found)"
fi
echo

echo "Potential deep selector chains (4+ levels):"
deep_chains="$(rg -n "([\\.#][a-zA-Z0-9_-]+[[:space:]>+~]+){3,}[\\.#][a-zA-Z0-9_-]+" "$root" -g '*.scss' | head -n 40 || true)"
if [ -n "$deep_chains" ]; then
  printf '%s\n' "$deep_chains"
else
  echo "  (none found)"
fi
