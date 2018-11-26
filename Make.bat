@echo off
xelatex USTBExam-teacher.tex
xelatex USTBExam-teacher.tex

xelatex USTBExam-demo.tex
xelatex USTBExam-demo.tex

xelatex USTBExam-A3.tex
xelatex USTBExam-A3.tex

del  *.aux *.bak *.bbl *.blg *.dbj *.dvi *.ent *.glg *.glo *.gls *.gz *.idx *.ilg *.ind *.lof *.log *.lot *.out *.ps *.thm *.synctex *.thm *.toc

REM pause