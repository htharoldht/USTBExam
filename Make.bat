@echo off
for %%B in (*.tex) do latexindent -w -m -l "%%B"

xelatex USTBExam-teacher.tex
xelatex USTBExam-teacher.tex

xelatex USTBExam-demo.tex
xelatex USTBExam-demo.tex

xelatex USTBExam-A3.tex
xelatex USTBExam-A3.tex

del  *.aux *.bak *.bbl *.blg *.dbj *.dvi *.ent *.glg *.glo *.gls *.gz *.idx *.ilg *.ind *.lof *.log *.lot *.out *.ps *.thm *.synctex *.thm *.toc *.bak*

REM pause