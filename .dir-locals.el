((nil . ((org-latex-classes .
                            (("book"
                              "\\documentclass[]{scrbook}"
                              ("\\chapter{%s}" . "\\addchap{%s}")
                              ("\\section{%s}" . "\\addsec{%s}")
                              ("\\subsection{%s}" . "\\subsection*{%s}")
                              ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
         (org-latex-src-block-backend . listings)
         (org-latex-listings-options . (("backgroundcolor" "\\color{white}")
                                        ("commentstyle" "\\color{green}")
                                        ("keywordstyle" "\\color{magenta}")
                                        ("numberstyle" "\\color{gray}")
                                        ("stringstyle" "\\color{purple}")
                                        ("basicstyle" "\\ttfamily")
                                        ("breakatwhitespace" "false")
                                        ("breaklines" "true")
                                        ("captionpos" "b")
                                        ("keepspaces" "true")
                                        ("numbers" "left")
                                        ("numbersep" "5pt")
                                        ("showspaces" "false")
                                        ("showstringspaces" "false")
                                        ("showtabs" "false")
                                        ("tabsize" "2")))
         (org-latex-prefer-user-labels . t)
         (org-html-prefer-user-labels . t)
         (org-latex-toc-command . "\\frontmatter\n\\addchap{Table of Contents}\n\\label{chap:toc}\n\\listoftoc*{toc}\n\n")
         (fill-column . 200)))
 (org-mode . ((eval . (progn (visual-line-mode)
                             (org-toggle-link-display)
                             (add-to-list
                              'org-export-smart-quotes-alist
                              '("en-gb" (primary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
                                (primary-closing :utf-8 "”" :html "&rdquo;" :latex "''" :texinfo "''")
                                (secondary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
                                (secondary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
                                (apostrophe :utf-8 "’" :html "&rsquo;"))))))))
