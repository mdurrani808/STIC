#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SLIDES_SRC="$REPO_ROOT/slides"
SLIDES_OUT="$REPO_ROOT/public/slides"
EXPORT_EL="$REPO_ROOT/scripts/export-slides.el"

rm -rf "$SLIDES_OUT"
mkdir -p "$SLIDES_OUT"

for topic_dir in "$SLIDES_SRC"/*/; do
  topic=$(basename "$topic_dir")
  dest="$SLIDES_OUT/$topic"
  mkdir -p "$dest"

  org_file="$topic_dir$topic.org"
  rvl_file="$topic_dir$topic.rvl"
  html_file="$topic_dir$topic.html"
  pdf_file="$topic_dir$topic.pdf"
  files_dir="$topic_dir${topic}_files"

  if [ -f "$org_file" ]; then
    echo "==> [$topic] Building from .org source..."
    (
      cd "$topic_dir"
      emacs --batch \
        --load "$EXPORT_EL" \
        --visit "$topic.org" \
        --eval "(org-beamer-export-to-latex nil nil nil nil nil)"
      xelatex -shell-escape -interaction nonstopmode "$topic.tex" || true
      xelatex -shell-escape -interaction nonstopmode "$topic.tex" || true
      if [ ! -f "$topic.pdf" ]; then
        echo "ERROR: [$topic] xelatex failed to produce a PDF." >&2
        exit 1
      fi
      beamer-reveal.pl "$topic"
    )
  elif [ -f "$html_file" ]; then
    echo "==> [$topic] Using pre-compiled HTML..."
  elif [ -f "$rvl_file" ]; then
    echo "==> [$topic] Building from .rvl..."
    (
      cd "$topic_dir"
      beamer-reveal.pl "$topic"
    )
  else
    echo "WARNING: [$topic] No usable source found, skipping."
    continue
  fi

  [ -f "$html_file" ] && cp "$html_file" "$dest/"
  [ -d "$files_dir" ] && cp -r "$files_dir" "$dest/"
  [ -f "$org_file" ] && cp "$org_file" "$dest/"
  [ -f "$pdf_file" ] && cp "$pdf_file" "$dest/"

  echo "    -> $dest"
done

echo ""
echo "Slides built successfully into $SLIDES_OUT"
