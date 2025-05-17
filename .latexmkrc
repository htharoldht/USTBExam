# 清理所有生成文件
$clean_ext = 'aux bbl blg idx ind lof lot out toc acn acr alg glg glo gls ist fls listing hd dvi xdv fdb_latexmk bak*';

# 设置默认编译器和参数

# ======================================================================================
# PDF Generation/Building/Compilation
# ======================================================================================

# PDF-generating modes are:
# 1: pdflatex, as specified by $pdflatex variable (still largely in use)
# 2: postscript conversion, as specified by the $ps2pdf variable (useless)
# 3: dvi conversion, as specified by the $dvipdf variable (useless)
# 4: lualatex, as specified by the $lualatex variable (best)
# 5: xelatex, as specified by the $xelatex variable (second best)
$pdf_mode = 1;
$pdflatex = 'latexmk -xelatex -interaction=nonstopmode -shell-escape -synctex=1 -halt-on-error -pvc %S';

# # Output directory
# $out_dir = "build";

# # 设置中间文件目录
# $aux_dir = 'build';

# Show used CPU time. Looks like: https://tex.stackexchange.com/a/312224/120853
$show_time = 1;

@default_files = ('*.tex');

# 手动添加 ./body 目录中的 .tex 文件
for my $file (glob 'body/*.tex') {
    push @default_files, $file;
}
