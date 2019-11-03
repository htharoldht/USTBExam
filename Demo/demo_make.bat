@echo off
xelatex 2017-2018-2_teacher.tex
xelatex 2017-2018-2_teacher.tex

xelatex 2017-2018-2_student.tex
xelatex 2017-2018-2_student.tex

xelatex 2017-2018-2_A3.tex
xelatex 2017-2018-2_A3.tex

del  *.aux *.bak *.bbl *.blg *.dbj *.dvi *.ent *.glg *.glo *.gls *.gz *.idx *.ilg *.ind *.lof *.log *.lot *.out *.ps *.thm *.synctex *.thm *.toc

REM pause