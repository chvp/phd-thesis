;;; build.el --- Build book.pdf non-interactively -*- lexical-binding: t -*-
;;; Commentary:
;;; This is used to build my PhD thesis from scripts (e.g. to create a diffed version).
;;; Code:

(package-initialize)
(require 'org)
(require 'oc-csl)
(require 'ox)

(setq org-latex-classes '(("book"
                           "\\documentclass[]{scrbook}"
                           ("\\chapter{%s}" . "\\addchap{%s}")
                           ("\\section{%s}" . "\\addsec{%s}")
                           ("\\subsection{%s}" . "\\subsection*{%s}")
                           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
      org-latex-caption-above nil
      org-latex-src-block-backend 'minted
      org-latex-minted-options '(("linenos" . "true")
                                 ("breaklines" . "true"))
      org-latex-prefer-user-labels t
      org-latex-subtitle-format "\\subtitle{%s}"
      org-latex-subtitle-separate t)

(add-to-list
 'org-export-smart-quotes-alist
 '("en-gb" (primary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
   (primary-closing :utf-8 "”" :html "&rdquo;" :latex "''" :texinfo "''")
   (secondary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
   (secondary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
   (apostrophe :utf-8 "’" :html "&rsquo;")))

(find-file "book.org")
(org-latex-export-to-latex)

(provide 'build)
;;; build.el ends here
