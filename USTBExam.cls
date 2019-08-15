\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{USTBExam}[2018/06/29 v1.0 An exam class for USTB]

% 是否显示答案
\newif\ifanswer

\DeclareOption{answer}{\answertrue}
\DeclareOption{noanswer}{\answerfalse}

%其它选项
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}

%不可省略
\ProcessOptions

\ExecuteOptions{answer}

% 四号  小四号 五号    小五号
% 14bp  12bp    10.5bp  9bp
\LoadClass[cs4size,UTF8,noindent]{ctexart}

\RequirePackage[a4paper,left=30mm,right=30mm,top=25mm,bottom=25mm]{geometry}
\RequirePackage{amsmath,amssymb}
\RequirePackage{multirow}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{comment}
% \RequirePackage{environ}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{enumitem}
\RequirePackage{CJKnumb}
\RequirePackage{makecell}
\RequirePackage{tabularx}
\RequirePackage{interfaces-makecell}
% \RequirePackage{zref-lastpage}
\RequirePackage{tikz}

\RequirePackage{hyperref,etoolbox}
\AtBeginDocument{%
  \hypersetup{
    pdfinfo={
      Title    = {\@title},
      Author   = {\@author},
      Subject  = {\USTB@Subject},
      Keywords = {\USTB@Keywords},
    },
    colorlinks = true,
    hidelinks  = true,
  }
}
\setlength{\parindent}{0em}
\setlength{\lineskiplimit}{3pt}
\setlength{\lineskip}{3pt}

\newcommand{\Subject}[1]{\def\USTB@Subject{#1}}
\newcommand{\Keywords}[1]{\def\USTB@Keywords{#1}}
\newcommand{\Year}[1]{\def\USTB@Year{#1}}
\newcommand{\Semester}[1]{\def\USTB@Semester{#1}}
\newcommand{\Course}[1]{\def\USTB@Course{#1}}
\newcommand{\Type}[1]{\def\USTB@Type{#1}}
\newcommand{\TotalPart}[1]{\setcounter{TotalPart}{#1}}

\newcommand{\underspace}[1]{\underline{\hspace{#1}}}

\newcounter{TotalPart}
\newcounter{SubColumn}
\newcounter{EmptyColumn}

\setcounter{TotalPart}{1}

% 计分表制作
\newcommand{\ScoreTableA}{
  \setcounter{SubColumn}{\value{TotalPart}+2}
  \setcounter{EmptyColumn}{\value{TotalPart}+4}
  \begin{tabularx}{\textwidth}{|*{\theSubColumn}{X<{\centering}|}*{3}{c|}}
    \hline
      \multicolumn{\theSubColumn}{|c|}{\multirow{2}{*}{试卷卷面成绩}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{课程考核成绩占~\%}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{平时成绩占\,\%}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{课程考核成绩}}
    \\
      \multicolumn{\theSubColumn}{|c|}{}
      & & &
    \\
    \cline{1-\theSubColumn}
      \hfill 题 \hfill 号 \hfill~
      & \repeatcell{\theTotalPart}{text=\CJKnumber{\column}}
      & \hfill 小 \hfill 计 \hfill~
      & & &
    \\
    \hline
      \hfill 得 \hfill 分 \hfill~
      & \eline{\theEmptyColumn}
    \\
    \hline
  \end{tabularx}
}

\newcommand{\ScoreTableB}{
  \setcounter{SubColumn}{\value{TotalPart}+2}
  \setcounter{EmptyColumn}{\value{TotalPart}+4}
  \begin{tabularx}{\textwidth}{|c|*{\theTotalPart}{X<{\centering}|}*{4}{c|}}
    \hline
      \multicolumn{\theSubColumn}{|c|}{\multirow{2}{*}{试卷卷面成绩}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{课程考核成绩占~\%}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{平时成绩占\,\%}}
      & \multicolumn{1}{c|}{\multirow{3}{3em}{课程考核成绩}}
    \\
      \multicolumn{\theSubColumn}{|c|}{}
      & & &
    \\
    \cline{1-\theSubColumn}
      题号
      & \repeatcell{\theTotalPart}{text=\CJKnumber{\column}}
      & 小计
      & & &
    \\
    \hline
      得分
      & \eline{\theEmptyColumn}
    \\
    \hline
  \end{tabularx}
}

% 试卷头制作
\newcommand{\makehead}{
  \begin{center}
    \parbox{\textwidth}{\centering \LARGE \bfseries 北京科技大学 \USTB@Year 学年 \, 第~\USTB@Semester~学期 \\
    \underline{\quad \USTB@Course \quad} \, 试卷（\USTB@Type 卷 \ifanswer{解析}\fi）}

    \vspace{1em}
    院(系) \hrulefill~  班级 \hrulefill~
    姓名 \hrulefill~  学号 \hrulefill\mbox{}
    \vspace{0.5em}
    \ifthenelse{\theTotalPart=0}{}{\ifthenelse{\theTotalPart<6}{\ScoreTableA}{\ScoreTableB}}
    \vspace*{-2em}
  \end{center}
}

\newcommand{\my@foottext}{\USTB@Course 试卷 \ifanswer{解析}\fi \quad 第~\thepage~页~共~\pageref{LastPage}~页}

% 去掉页眉下划线
\renewcommand{\headrulewidth}{0pt}
% 装订线页眉外侧超宽6em
\fancyheadoffset[L]{6em}
\fancyhf{}
\pagestyle{fancy}
\cfoot{\small\my@foottext}
\lhead{
  \ifthenelse{\isodd{\thepage}}{
    \mifengxian
  }{}
}

\newcommand{\mifengxian}{
  \begin{tikzpicture}[remember picture,overlay,very thick,font=\normalsize]
    \path (current page.south west) +(2.5cm,1cm)  coordinate (a);
    \path (current page.north west) +(2.5cm,-1cm) coordinate (b);
    \node[text width=1em, xshift=1cm] at (current page.west) {
    自觉遵守考试规则\quad\hspace*{5pt}，诚信考试\quad\hspace*{5pt}，绝不作弊};
    \node[text width=1em, xshift=2cm] at (current page.west) {装订线内不要答题};
    \draw[dashed] (a) -- (b);
  \end{tikzpicture}
}

\newcounter{problem}

\newcommand{\makepart}[2]{
  \setcounter{problem}{0}
  \stepcounter{section}
  \vspace{1em}
  \begin{tabular}{|r|r}
    \cline{1-1}
      \multicolumn{1}{|c|}{\hfill 得 \hfill 分 \hfill~}
      & \multicolumn{1}{c}{\multirow{2}[3]{*}{\textbf{\Chinese{section}、#1}(#2)}}
      \\
    \cline{1-1}
      \parbox{\textwidth}{\vspace*{2.5em}}
      & \\
    \cline{1-1}
  \end{tabular}
  \vspace{1em}
}

\newcommand{\answer}[1]{
  \ifanswer{#1}\else\hphantom{#1}\fi
}

\newcommand{\fillin}[1]{
  \underline{\hspace{0.5em}\answer{#1}\hspace{0.5em}}
}

\newcommand{\pickout}[1]{
  \hfill(\makebox[1.5em]{\answer{#1}})
}

\newcommand{\pickin}[1]{
  (\makebox[1.5em]{\answer{#1}})
}

\newcommand{\ignorepars}{\@ifnextchar\par{\expandafter\ignorepars\@gobble}{}}

\newenvironment{problemreal}{
  \stepcounter{problem}
  \arabic{problem}.\ignorespaces
}{\par}
\newenvironment{solutionreal}{\textsf{解}\quad\ignorepars}{\ifanswer\hfill\ensuremath{\square}\bigskip\fi\par}
\newenvironment{proofreal}{\textsf{证明}\quad\ignorepars}{\ifanswer\hfill\ensuremath{\square}\bigskip\fi\par}
\newenvironment{analysisreal}{\textsf{解析}\quad\ignorepars}{\ifanswer\hfill\ensuremath{\square}\bigskip\fi\par}

\newenvironment{problem}{\problemreal}{\endproblemreal}
\newenvironment{solution}{\solutionreal}{\endsolutionreal}
\newenvironment{proof}{\proofreal}{\endproofreal}
\newenvironment{analysis}{\analysisreal}{\endanalysisreal}

% 增加只在试卷里面换页的命令
\newcommand{\mynewpage}{\ifanswer\else\newpage\fi}
\newcommand{\myvfill}{\ifanswer\else\vfill\fi}

\AtBeginDocument{
  \ifanswer\else
    \excludecomment{solution}
    \excludecomment{proof}
    \excludecomment{analysis}
  \fi
}

\newlength{\xxla}
\newlength{\xxlb}
\newlength{\xxlc}
\newlength{\xxld}
\newlength{\lhalf}
\newlength{\lquarter}
\newlength{\lmax}

\newcommand{\options}[4]{
  \par
  \settowidth{\xxla}{(A)~#1~~~}
  \settowidth{\xxlb}{(B)~#2~~~}
  \settowidth{\xxlc}{(C)~#3~~~}
  \settowidth{\xxld}{(D)~#4~~~}

  \ifthenelse{\lengthtest{\xxla>\xxlb}}{\setlength{\lmax}{\xxla}}{\setlength{\lmax}{\xxlb}}
  \ifthenelse{\lengthtest{\xxlc>\lmax}}{\setlength{\lmax}{\xxlc}}{}
  \ifthenelse{\lengthtest{\xxld>\lmax}}{\setlength{\lmax}{\xxld}}{}
  \setlength{\lhalf}{0.5\linewidth}
  \setlength{\lquarter}{0.25\linewidth}
  \ifthenelse{\lengthtest{\lmax>\lhalf}}
  {
    \begin{enumerate}[label=(\Alph*),parsep=0ex,itemsep=0ex,leftmargin=2em, topsep=0ex]
      \item #1
      \item #2
      \item #3
      \item #4
    \end{enumerate}
  }
  {
    \ifthenelse{\lengthtest{\lmax>\lquarter}}
    {
      \makebox[\lhalf][l]{(A)~#1~~~}%
      \makebox[\lhalf][l]{(B)~#2~~~}%

      \makebox[\lhalf][l]{(C)~#3~~~}%
      \makebox[\lhalf][l]{(D)~#4~~~}%
    }
    {
      \makebox[\lquarter][l]{(A)~#1~~~}%
      \makebox[\lquarter][l]{(B)~#2~~~}%
      \makebox[\lquarter][l]{(C)~#3~~~}%
      \makebox[\lquarter][l]{(D)~#4~~~}%
    }
  }
}