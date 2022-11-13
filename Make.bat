@echo off
for %%B in (**.tex) do latexindent -w -m -l "%%B"

latexmk -xelatex -interaction=nonstopmode -shell-escape -synctex=1 demo.tex

del  **.aux, **.bbl, **.blg, **.idx, **.ind, **.lof, **.lot, **.out, **.toc, **.acn, **.acr, **.alg, **.glg, **.glo, **.gls, **.ist, **.fls, **.log, **.listing, **.hd, **.dvi, **.xdv, **.fdb_latexmk, **.bak*

REM pause