;;; Minimal Emacs batch config for org-mode Beamer export in CI.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'ox-beamer)
