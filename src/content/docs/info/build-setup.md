---
title: Build Setup
description: How to build and develop the CMSC398W course site locally.
---

This page documents how to build the course site and generate slides from source.

## Prerequisites

| Tool | Purpose | Install |
|------|---------|---------|
| Node.js 22+ | Astro site | [nodejs.org](https://nodejs.org) |
| Emacs (with `ox-beamer`) | Export `.org` → `.tex` | `brew install emacs` |
| TeXLive (XeLaTeX) | Compile `.tex` → `.pdf` + `.rvl` | [tug.org/texlive](https://tug.org/texlive/) |
| Poppler (`pdftoppm`) | Slide image extraction | `brew install poppler` |
| Perl + BeamerReveal | Convert `.rvl` → Reveal.js HTML | `cpanm BeamerReveal` |

## Local Development

Install npm dependencies once:

```bash
npm install
```

Generate slides into `public/slides/` (required before `dev` or `build`):

```bash
bash scripts/build-slides.sh
```

Start the dev server:

```bash
npm run dev
# → http://localhost:4321/STIC/
```

## Adding or Updating Slides

1. Edit or create the `.org` file in `slides/<topic>/`
2. Re-run `bash scripts/build-slides.sh`
3. The dev server will pick up the new files automatically

The build script priority per topic directory:

| Condition | Action |
|---|---|
| `.org` exists | Full pipeline: Emacs → xelatex → beamer-reveal.pl |
| `.html` exists (no `.org`) | Copy as-is |
| `.rvl` exists (no `.html`) | Run beamer-reveal.pl only |

## Adding a New Slide Topic

1. Create `slides/<topic>/` and add the `.org` source file
2. Add a new MDX page at `src/content/docs/slides/<topic>.mdx`
3. Add an entry to the sidebar in `astro.config.mjs`

## Deployment

Pushing to `main` triggers the GitHub Actions workflow (`.github/workflows/deploy.yml`), which installs all dependencies, runs `scripts/build-slides.sh`, builds the Astro site, and deploys to GitHub Pages at `https://mdurrani808.github.io/STIC/`.
