((nil . ((org-latex-classes .
                            (("book"
                              "\\documentclass[]{scrbook}"
                              ("\\chapter{%s}" . "\\addchap{%s}")
                              ("\\section{%s}" . "\\addsec{%s}")
                              ("\\subsection{%s}" . "\\subsection*{%s}")
                              ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
         (org-latex-caption-above . nil)
         (org-latex-src-block-backend . minted)
         (org-latex-minted-options . (("linenos" . "true")))
         (org-latex-prefer-user-labels . t)
         (org-latex-pdf-process . ("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
         (org-html-prefer-user-labels . t)
         (org-latex-toc-command . "\\frontmatter\n\\addchap{Table of Contents}\n\\label{chap:toc}\n\\listoftoc*{toc}\n\n")
         (flycheck-languagetool-language . "en-GB")
         (fill-column . 200)))
 (org-mode . ((eval . (progn (visual-line-mode)
                             (org-toggle-link-display)
                             (require 'ox)
                             (add-to-list
                              'org-export-smart-quotes-alist
                              '("en-gb" (primary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
                                (primary-closing :utf-8 "”" :html "&rdquo;" :latex "''" :texinfo "''")
                                (secondary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
                                (secondary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
                                (apostrophe :utf-8 "’" :html "&rsquo;"))))))))
