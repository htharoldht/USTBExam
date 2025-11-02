\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {USTBExam} {2025-11-02} {v2.3.8} {An exam template for USTB}

\AddToHook{package/exam-zh-symbols/before}{%
    \AtBeginDocument{\let\savedsim=\sim}
  }
\AddToHook{package/exam-zh-symbols/after}{%
    \AtBeginDocument{\let\sim=\savedsim}
  }

% 加载文档类和宏包
\LoadClass {exam-zh}

% 处理文档类选项
\PassOptionsToClass { UTF8,  scheme = chinese, openany } { exam-zh }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { exam-zh } }
\ProcessOptions*

% 使用 l3keys 定义 \ustbexamsetup 配置命令
\NewDocumentCommand \ustbexamsetup { m }
  { \keys_set:nn { ustb-exam } {#1} }

% 全局配置
\keys_define:nn { ustb-exam / global }
  {
    watermark .tl_set:N = \l__ustbexam_global_watermark,
  }
\keys_set:nn { ustb-exam / global }
  {
    watermark = {},
  }
\keys_define:nn { ustb-exam }
  { global .meta:nn = { ustb-exam / global } {#1} }

\AtEndPreamble
  {
    \tl_if_empty:NF { \l__ustbexam_global_watermark }
      {
        \RequirePackage{background}
        \backgroundsetup{
            scale=1, % 调整大小
            angle=0, % 调整角度
            opacity=0.15, % 调整透明度
            pages=all, % 应用到所有页面
            position=current~page.center, % 确保在页面正中心
            contents={
                \includegraphics[width=0.6\paperwidth, keepaspectratio]{\l__ustbexam_global_watermark}
              }
          }
      }
  }

% 试卷内标题处的参数
\keys_define:nn { ustb-exam / title }
  {
    year       .int_set:N = \l__ustbexam_title_year_int,
    semester   .tl_set:N  = \l__ustbexam_title_semester,
    course     .tl_set:N  = \l__ustbexam_title_course_str,
    suffix     .tl_set:N  = \l__ustbexam_title_suffix_str,
    type       .str_set:N = \l__ustbexam_title_type_str,
    total-part .int_set:N = \l__ustbexam_title_total_part_int,
  }
\keys_set:nn { ustb-exam / title }
  {
    year       = {\the\year},
    semester   = {一},
    course     = {微积分AI},
    suffix     = {},
    type       = {A},
    total-part = {4},
  }
\keys_define:nn { ustb-exam }
  { title .meta:nn = { ustb-exam / title } {#1} }

% PDF 配置
\keys_define:nn { ustb-exam / pdf }
  {
    title    .tl_set:N = \l__ustbexam_pdf_title,
    subject  .tl_set:N = \l__ustbexam_pdf_subject,
    author   .tl_set:N = \l__ustbexam_pdf_author,
    keywords .tl_set:N = \l__ustbexam_pdf_keywords,
  }
\keys_set:nn { ustb-exam / pdf }
  {
    title    = \l_ustbexam_title_tl,
    subject  = {},
    author   = \@author,
    keywords = {},
  }
\keys_define:nn { ustb-exam }
  { pdf .meta:nn = { ustb-exam / pdf } {#1} }

\AtBeginDocument
  {
    \hypersetup{
        pdfinfo={
            Title    = {\l__ustbexam_pdf_title},
            Author   = {\l__ustbexam_pdf_author},
            Subject  = {\l__ustbexam_pdf_subject},
            Keywords = {\l__ustbexam_pdf_keywords},
          },
        colorlinks = true,
        linkcolor  = black,
      }
  }

% title 里的课程名
\tl_new:N \l__ustbexam_title_course_real
\AtBeginDocument{
    \str_if_empty:NF {\l__ustbexam_title_course_str}
      {
        \hbox_set:Nn \l_tmpa_box {\l__ustbexam_title_course_str}
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box * 2 }
        \tl_set:Nn \l__ustbexam_title_course_real
          {
            \__examzh_spread_box:nn { \l_tmpa_dim } { \l__ustbexam_title_course_str }
          }
      }
  }

% 是否期中
\tl_new:N \l__ustbexam_title_suffix_real
\tl_set:Nn \l__ustbexam_title_suffix_real { 试卷 }

% 在文档开始前处理 suffix
\AtBeginDocument{
    \tl_if_empty:NF \l__ustbexam_title_suffix_str
      {
        \tl_set:Nx \l__ustbexam_title_suffix_real { \l__ustbexam_title_suffix_str 试卷 }
      }
  }

% 试卷类型
\tl_new:N \l__ustbexam_title_type_real
\tl_set:Nn \l__ustbexam_title_type_real
  {
    \bool_if:NTF \l__examzh_question_show_paren_answer_bool
      { （\str_use:N \l__ustbexam_title_type_str 卷解析）}
      { （\str_use:N \l__ustbexam_title_type_str 卷） }
  }

% 标题
\tl_new:N \l_ustbexam_title_tl
\AtBeginDocument{
    \tl_set:Nn \l_ustbexam_title_tl
      {
        \int_eval:n { \l__ustbexam_title_year_int } -- \int_eval:n {\l__ustbexam_title_year_int + 1} ~学年\,%
        第 \l__ustbexam_title_semester{} 学期 \l__ustbexam_title_course_str \l__ustbexam_title_suffix_real \l__ustbexam_title_type_real
      }
  }

% 定义计数器, 自动获取大题数目
\newcounter{sectioncounter}

% 使用钩子在每次调用 \section 和 \section* 时递增计数器
\AddToHook{ cmd / section / before }{ \stepcounter{sectioncounter} }

% 脚注编号每页清零
\AddToHook{ shipout / before }
  {
    \global\c@footnote=0
  }

% 暂时不做自动获取, 有困难需解决

% 输出标题
\RenewDocumentCommand \maketitle { }
  {
    \cleardoublepage
    \chapter{北京科技大学 \l_ustbexam_title_tl}
    \begingroup
    \begin { center }
    \let \footnote \thanks
      {
        \kaishu
        \LARGE \bfseries 北京科技大学~ \int_eval:n { \l__ustbexam_title_year_int } -- \int_eval:n {\l__ustbexam_title_year_int + 1} ~学年\,%
        第~ \l__ustbexam_title_semester{} ~学期 \par
        \underline{\quad \l__ustbexam_title_course_real \quad} \l__ustbexam_title_suffix_real \l__ustbexam_title_type_real
      }
    \end { center }
    \endgroup
    \begingroup
      {
        \kaishu
        院(系)\hrulefill\,~
        班级\hrulefill\,~
        姓名\hrulefill\,~
        学号\hrulefill\,~
        考试教室\hrulefill\,
      }
    \endgroup
    \begingroup
      {\kaishu \bfseries \ScoreTable { \l__ustbexam_title_total_part_int } }
    \endgroup
    \begingroup
      {\par 说明：}
    \begin{minipage}[t]{.9\textwidth}
      1、要求正确地写出主要计算或推导过程，过程有错或只写答案者不得分；\par
      2、 考场、学院、班级、学号、姓名均需写全，不写全的试卷为废卷；\par
      3、 涂改学号及姓名的试卷为废卷；\par
      4、 请在试卷上答题，在其他纸张上的解答一律无效.
    \end{minipage}
    \endgroup
  }

% 输出计分表
\RequirePackage{makecell,tabularx}

% https://tex.stackexchange.com/questions/625226/alternative-to-repeatcell-from-the-interfaces-package-since-texlive-2021/625249#625249
% we need LaTeX counters and not expl3 ones because of tabularx two-step process
\newcounter{repeatstart}
\newcounter{repeatcurrent}
\newcounter{repeatlast}

\NewDocumentCommand{\repeatcell}{ m m }
  { % #1 = number of repeats
    % #2 = key-value pairs
    \oaheix_repeatcell:nn { #1 } { #2 }
  }

\tl_new:N \l__oaheix_repeatcells_body_tl

\keys_define:nn { oaheix/repeatcells }
  {
    text  .code:n  = \cs_gset_protected:Nn \__oaheix_repeatcell_text:n { #1 },
    start .code:n = \setcounter{repeatstart}{#1},
  }

\cs_new_protected:Nn \oaheix_repeatcell:nn
  {
    \keys_set:nn { oaheix/repeatcells } { #2 }
    \tl_clear:N \l__oaheix_repeatcells_body_tl
    \int_step_inline:nnn
      { \value{repeatstart} + 1 }
      { \value{repeatstart} + #1 }
      {
        \tl_put_right:Nx \l__oaheix_repeatcells_body_tl
          {
            \int_compare:nF { ##1 = \value{repeatstart} + 1 } { & }
            \__oaheix_repeatcell_text:n { ##1 }
          }
      }
    \tl_use:N \l__oaheix_repeatcells_body_tl
    \setcounter{repeatlast} { \int_eval:n { \value{repeatstart} + #1 } }
  }

\NewExpandableDocumentCommand{\lastvalue}{}{\int_eval:n { \value{repeatlast} } }

\AtBeginEnvironment{tabularx}{\setcounter{repeatstart}{0}}

% 计分表制作
\NewDocumentCommand \ScoreTable { m } {
    \begin{ center }
    \int_compare:nTF { #1 > 0 }
      {
        \begin{tabularx}
          {\textwidth}{ |p{4em}<{\centering} *{#1}{|X<{\centering}} | c |}
          \hline
          题号 & \repeatcell{#1}{text = \zhnumber{##1}} & \makecell[c]{{\tiny ~} \\[-.9em]课程考核成绩\\[-.9em]{\tiny ~}} \\
          \hline
          得分 & \eline{\int_eval:n { #1 + 1} }                                  \\
          \hline
        \end{tabularx}
      }{
        \begin{tabularx}
          {\textwidth}{ |p{4em}<{\centering} | X<{\centering} | }
          \hline
          题号 & \makecell[c]{{\tiny ~} \\[-.9em]课程考核成绩\\[-.9em]{\tiny ~}} \\
          \hline
          得分 &                        \\
          \hline
        \end{tabularx}
      }
    \end{ center }
  }

% 默认图片路径
\graphicspath{
    {./figs}{../figs}{body/figs}
      {./Figs}{../Figs}{body/Figs}
  }

% 默认的 enumerate 环境
\setlist[enumerate]{label=(\arabic*), left=\parindent, itemsep=0pt, align=left, parsep=0pt, topsep=0pt}
\setlist[enumerate,2]{label=(\roman*), left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}
% 默认的 itemize 环境
\setlist[itemize]{left=\parindent, itemsep=0pt, parsep=0pt, topsep=0pt}
\setlist[itemize,2]{left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}
% 默认的 description 环境
\setlist[description]{leftmargin=\parindent, itemsep=0pt, parsep=0pt, topsep=0pt}
\setlist[description,2]{left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}

\newlist{inenum}{enumerate*}{2}
\setlist[inenum]{(1), itemjoin={\quad}}

% 更新日志
\RequirePackage{changelog,translations}
\DeclareTranslation{English}{changelog-Added}{新增}
\DeclareTranslation{English}{changelog-Changed}{修改}
\DeclareTranslation{English}{changelog-Deprecated}{即将舍弃}
\DeclareTranslation{English}{changelog-Removed}{移除}
\DeclareTranslation{English}{changelog-Fixed}{纠错}
\DeclareTranslation{English}{changelog-Security}{安全}
\DeclareTranslation{English}{changelog-Miscellaneous}{其他}
\DeclareTranslation{English}{changelog-Unreleased}{即将发布}
\DeclareTranslation{English}{changelog-Yanked}{警醒}

% 页眉页脚
\fancypagestyle{myEmptyPage}{
    \fancyhf{}
    \cfoot{\thepage}
  }

% 已废弃
\NewDocumentCommand \backcover { }
  {
    \int_if_odd:nTF \c@page
      {
        { \clearpage \hbox:n { } \thispagestyle{empty} }
          { \setcounter{page}{\thepage - 1} }
      }
      {
        { \cleardoublepage \hbox:n { } \thispagestyle{empty} }
          { \setcounter{page}{\thepage - 2} }
      }
  }

\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \int_if_odd:nF \c@page
      { \hbox:n { } \thispagestyle { empty } \newpage }
  }

\RequirePackage{tocloft}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\contentsname}{\centerline{\LARGE 目\quad 录}}
\tocloftpagestyle{myEmptyPage}

\setlength{\parindent}{0em}

\RequirePackage{zref-user, refcount}

% 定义一个命令：取 RealLastPage 页码 - 1，且不小于 1
\NewDocumentCommand \realLastPageMinusOne {} {
    \int_eval:n {
        \int_max:nn { 1 } { \zref@extractdefault{RealLastPage}{page}{0} - 1 }
      }
  }

\examsetup{
    page = {
        foot-content = {
            \kaishu \l_ustbexam_title_tl \, 第~\thepage~页 \quad 共~\realLastPageMinusOne~页
          },
        foot-type = common,
        show-chapter = false,
      },
    sealline = {
        show        = true,
        scope       = mod-2,
        circle-show = false,
        line-type   = dotted,
        odd-info-content = {{装},{订},{线},{内},{不},{要},{答},{题}},
        odd-info-xshift = 12mm,
        text = {自觉遵守考试规则，诚信考试，绝不作弊},% \\装订线内不要答题},
        text-direction-vertical = true,
        text-width = 0.6\textheight,
        text-format  = \normalfont,
        text-xshift = 20mm
      },
    choices/label=(\Alph*),
    scoringbox/type = onecolumn,
    symbols/change-frac-style = true,
    symbols/change-dfrac-style = true,
    solution/blank-type = manual,
    solution/label-content = {\color{blue}{\heiti 解}},
    solution/qedsymbol = {\color{blue}{$\square$}},
    question/show-answer = true,
    problem/show-answer = true,
    paren/show-answer = true,
    fillin/show-answer = true,
    paren/text-color=blue,
    fillin/text-color=blue,
    solution/text-color=blue,
  }

% 根据 exam-zh 版本号进行设置
\@ifclasslater { exam-zh } { 2024/02/12 }
  {
    % 版本大于等于 0.2.1
    \keys_set:nn { exam-zh } {
        solution/show-solution = show-stay,
        textfigure/fig-pos=right,
      }
    \ExamPrintAnswerSet{
        sealline/show=true,
        paren/show-answer=false,
        paren/show-paren=true,
        fillin/show-answer=false,
        solution/show-solution=hide,
        fillin/no-answer-type=none,
      }
  }
  {
    % 版本小于 0.2.1
    \keys_set:nn { exam-zh } { solution/show-answer = true }
    \ExamPrintAnswerSet{
        sealline/show=true,
        paren/show-answer=false,
        paren/show-paren=true,
        fillin/show-answer=false,
        solution/show-solution=false,
        fillin/no-answer-type=none,
      }
  }

% 封面配置
\keys_define:nn { ustb-exam / cover }
  {
    top      .tl_set:N = \l__ustbexam_cover_top,
    title    .tl_set:N = \l__ustbexam_cover_title,
    subtitle .tl_set:N = \l__ustbexam_cover_subtitle,
    author   .tl_set:N = \l__ustbexam_cover_author,
    date     .tl_set:N = \l__ustbexam_cover_date,
    bottom   .tl_set:N = \l__ustbexam_cover_bottom,
    bgimg    .tl_set:N = \l__ustbexam_cover_bgimg,
  }
\keys_set:nn { ustb-exam / cover }
  {
    top      = 北京科技大学,
    title    = 高等数学AI,
    subtitle = 历年期中试卷合集,
    author   = 黄腾,
    date     = \today,
    bottom   = 假装有出版社,
    bgimg    = {},
  }
\keys_define:nn { ustb-exam }
  { cover .meta:nn = { ustb-exam / cover } {#1} }

% 定义 makeCover 命令
\NewDocumentCommand \makeCover { }
  {
    \newgeometry{right=3.5cm, vmargin=2.5cm, headsep=0.5cm}
    \pagestyle{myEmptyPage}
    \begin{titlepage}
      \setcounter{page}{0}
      \tl_if_empty:NF { \l__ustbexam_cover_bgimg }
        {
          \begin{tikzpicture}[remember~picture, overlay]
            \node[opacity=0.2,rotate=30] at ([shift={(-2.0cm, 0)}]current~page.center)
              {
                \includegraphics[width=23cm]{\l__ustbexam_cover_bgimg}
              };
          \end{tikzpicture}
        }

      \centering

      \makebox[0.5\textwidth][s]{\huge \bfseries \l__ustbexam_cover_top}
      \par\addvspace{2.5cm}

      \begin{tcolorbox}
        [
        width=0.8\textwidth, height=4cm,
        halign=center, valign=center,
        blanker,
        frame~hidden, boxsep=0pt,
        borderline~horizontal={2pt}{0pt}{black},
        hyphenationfix,
        ]
        \Huge \bfseries
        \makebox[0.6\textwidth][s]{\l__ustbexam_cover_title}
        \par
        \makebox[0.75\textwidth][s]{\l__ustbexam_cover_subtitle}
      \end{tcolorbox}
      \par\addvspace{1.5cm}

      \parbox{0.4\textwidth}{\Large \centering \l__ustbexam_cover_author}
      \par\addvspace{1cm}

        {\l__ustbexam_cover_date}
      \par\vfill

      \makebox[0.3\textwidth][s]{\large \l__ustbexam_cover_bottom}
    \end{titlepage}
    \restoregeometry
  }

% 添加 RealLastPage 标记
\AddToHook{cmd/makeBackCover/before}{
    % 在正文最后一页打标记
    \zlabel{RealLastPage}
  }
\AddToHook{cmd/backcover/before}{
    % 在正文最后一页打标记
    \zlabel{RealLastPage}
  }

% 定义 makeBackCover 命令
\NewDocumentCommand \makeBackCover { }
  {
    % 移除密封线
    \RemoveFromHook { shipout / background } [ sealline ]

    \clearpage
    \int_if_odd:nTF { \value{page} }
      {
        % 当前页是奇数页，插入一页空白页
        \group_begin:
        \pagestyle{empty}
        \null \newpage
        \group_end:
      }
      {
        % 当前页是偶数页，插入两页空白页
        \group_begin:
        \pagestyle{empty}
        \null \newpage
        \null \newpage
        \group_end:
      }
  }

\NewDocumentEnvironment{analysis}{ O{} }
  {
    \begin{solution}[label-content={\color{blue}{\heiti 解析}},blank-type=none,#1]}{
    \end{solution}
  }
\NewDocumentEnvironment{note}{ O{} }
  {
    \begin{solution}[label-content=【尾注】,text-color=black,show-qed=false,parbreak=true,#1]
      \setlength{\parindent}{2em}}{
    \end{solution}
  }
\RenewDocumentEnvironment{proof}{ O{} }
  {
    \begin{solution}[label-content={\color{blue}{\heiti 证明}},blank-type=manual,#1]}{
    \end{solution}
  }

\DeclareTColorBox{pabox}{ O{ } m O{ blue } }
  {
    colback=#3!5!white,
    colframe=#3!45!gray,
    colbacktitle=#3!5!white,
    coltitle=#3!45!gray,
    titlerule=0mm,
    toprule=0mm,
    bottomrule=0mm,
    rightrule=0mm,
    leftrule=.5mm,
    boxsep=0mm,
    breakable,
    % frame hidden,
    % interior hidden,
    % detach title,
    % sharpish corners,
    fonttitle=\bfseries,
    label=#2,
    % title={\faMortarBoard~ #2},
    #1
  }

\RequirePackage{fontawesome, tikz}

\NewDocumentEnvironment{ notes }{ O{ } o o +b }
  {
    \bool_if:NTF \g__examzh_solution_show_bool
      {
        \begin{pabox}[]{\IfNoValueTF{#2}{#1}{#2}}[#3]
          \group_begin:
          {\color{blue!45!gray} \faMortarBoard~ {\bfseries #1}}
          \smallskip
          \par
          \group_end:
          \begingroup
          #4
          \endgroup
        \end{pabox}
      }
      {}
  }
  {}

\NewDocumentCommand \myref { m o }
  { 详见 第 ~\pageref{#1}~ 页 \IfNoValueTF{#2}{#1}{#2} }

\RequirePackage{mathtools,extarrows}

\RequirePackage{fixdif}
\newdif{\dif}{\mathrm{d}}

\DeclareMathOperator{\re}{e}
\DeclareMathOperator{\ri}{i}
\DeclareMathOperator{\cov}{cov}
\DeclareMathOperator{\sgn}{sgn}
\DeclareMathOperator{\rot}{\mathbf{rot}}
\DeclareMathOperator{\grad}{\mathbf{grad}}
\DeclareMathOperator{\divd}{\mathbf{div}}
\DeclareMathOperator{\ch}{ch}
\DeclareMathOperator{\sh}{sh}
\DeclareMathOperator{\arccot}{arccot}

\NewDocumentCommand \abs { m }
  {\left| #1 \right|}

\renewcommand{\Re}{\operatorname{Re}}
\renewcommand{\Im}{\operatorname{Im}}
\renewcommand{\le}{\leqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\ge}{\geqslant}
\renewcommand{\geq}{\geqslant}
\renewcommand{\parallel}{\mathrel{/\mskip-2.5mu/}}

\everymath{\displaystyle}
\allowdisplaybreaks

% 以下为兼容性代码
% ===== 弃用 begin =====

% 试卷头里的年份
\NewDocumentCommand \Year { m }
  { \int_set:Nn \l__ustbexam_title_year_int {#1} }

% 试卷头里的学期
\NewDocumentCommand \Semester { m }
  { \tl_set:Nn \l__ustbexam_title_semester {#1} }

% 试卷头里的课程
\NewDocumentCommand \Course { m }
  { \str_set:Nn \l__ustbexam_title_course_str { #1 } }

% 是否期中
\NewDocumentCommand \Suffix { m }
  { \tl_set:Nn \l__ustbexam_title_suffix_str {#1} }

% 试卷头里的类型，如A/B/模拟等
\NewDocumentCommand \Type { m }
  { \tl_set:Nn \l__ustbexam_title_type_str { #1 } }

% 试卷头计分表中大题的数目
\NewDocumentCommand \TotalPart { m }
  { \int_set:Nn \l__ustbexam_title_total_part_int {#1} }

% PDF 主题信息
\NewDocumentCommand \Subject { m }
  { \str_set:Nn \l__ustbexam_pdf_subject {#1} }

% PDF 关键词信息
\NewDocumentCommand \Keywords { m }
  { \str_set:Nn \l__ustbexam_pdf_keywords {#1} }

\NewDocumentCommand \makehead {}
  {\maketitle}

% 也可以用正则表达式替换
% \\options\{(.+?)\}[%\n ]+\{(.+?)\}[%\n ]+?\{(.+?)\}[%\n ]+?\{(.+?)\}[%\n ]+?\n
% =>
% \\begin{choices}\n\t\t\\item $1\n\t\t\\item $2\n\t\t\\item $3\n\t\t\\item $4\n\t\\end{choices}\n
\NewDocumentCommand \options { m m m m }
  {
    \begin{choices}
      \item #1
      \item #2
      \item #3
      \item #4
    \end{choices}
  }

% 也可以用正则表达式替换
% \\pickout\{([A-D])\} => \\pickout[$1]
\NewDocumentCommand \pickout { m }
  {\paren[#1]}

% 也可以用正则表达式替换
% \\fillin\{(.+)\} => \\fillin[$1]
% % 此处的兼容性代码实在是不会
% \let\savefillin=\fillin
% \AtBeginDocument{
%   \RenewDocumentCommand \fillin { m }
%     {\savefillin[#1]}
%   }

% 也可以用正则表达式替换
% \\makepart\{(.+?)\}\{(.+?)\} => \\section{$1（$2）}
\NewDocumentCommand \makepart { m m }
  {\section{#1（#2）}}

% ===== 弃用 end =====

\NewDocumentCommand \vempty { m }{
    \bool_if:NF \l__examzh_question_show_paren_answer_bool
      {
        \vspace*{#1}
      }
  }
\NewDocumentCommand \mynewpage { }{
    \bool_if:NF \l__examzh_question_show_paren_answer_bool
      {
        \newpage
      }
  }

