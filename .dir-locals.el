((nil . ((org-latex-classes .
                            (("book"
                              "\\documentclass[]{scrbook}"
                              ("\\chapter{%s}" . "\\addchap{%s}")
                              ("\\section{%s}" . "\\addsec{%s}")
                              ("\\subsection{%s}" . "\\subsection*{%s}")
                              ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
         (org-latex-src-block-backend . 'listings)
         (org-latex-prefer-user-labels . t)
         (org-html-prefer-user-labels . t)
         (org-latex-toc-command . "\\frontmatter\n\\addchap{Table of Contents}\n\\label{chap:toc}\n\\listoftoc*{toc}\n\n")
         (fill-column . 200)))
 (org-mode . ((eval . (progn (visual-line-mode)
                             (org-toggle-link-display))))))
