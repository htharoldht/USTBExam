@echo off
xelatex demo_teacher.tex
xelatex demo_teacher.tex

xelatex demo_student.tex
xelatex demo_student.tex

xelatex demo_A3.tex
xelatex demo_A3.tex

del  *.aux *.bak *.bbl *.blg *.dbj *.dvi *.ent *.glg *.glo *.gls *.gz *.idx *.ilg *.ind *.lof *.log *.lot *.out *.ps *.thm *.synctex *.thm *.toc

REM pause