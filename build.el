;;; build.el --- Build book.pdf non-interactively -*- lexical-binding: t -*-
;;; Commentary:
;;; This is used to build my PhD thesis from scripts (e.g. to create a diffed version).
;;; Code:

(package-initialize)
(require 'org)
(require 'oc-csl)

(setq org-latex-classes '(("book"
                           "\\documentclass[11pt]{scrbook}"
                           ("\\chapter{%s}" . "\\addchap{%s}")
                           ("\\section{%s}" . "\\addsec{%s}")
                           ("\\subsection{%s}" . "\\subsection*{%s}")
                           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
      org-latex-src-block-backend 'listings
      org-latex-prefer-user-labels t)

(find-file "book.org")
(org-latex-export-to-latex)

(provide 'build)
;;; build.el ends here
