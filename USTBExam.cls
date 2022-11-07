\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {USTBExam} {2022-11-04} {v2.0} {An exam template for USTB}

\AddToHook{package/exam-zh-symbols/before}{%
  \AtBeginDocument{\let\savedsim=\sim}
}
\AddToHook{package/exam-zh-symbols/after}{%
  \AtBeginDocument{\let\sim=\savedsim}
}

% 加载文档类和宏包
\LoadClass {exam-zh}

% 处理文档类选项
\PassOptionsToClass { UTF8 , scheme = chinese, openany } { exam-zh }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { exam-zh } }
\ProcessOptions*

% 使用 l3keys 定义 \ustbexamsetup 配置命令
\NewDocumentCommand \ustbexamsetup { m }
  { \keys_set:nn { ustb-exam } {#1} }

% 定义 ustb-exam 宏包选项

% 是否显示答案
% \bool_new:N \l_ustbexam_show_answer_bool
% \bool_if:NTF \l__examzh_question_show_paren_answer_bool
%   { \bool_set_true:N \l_ustbexam_show_answer_bool }
%   { \bool_set_false:N \l_ustbexam_show_answer_bool }

% 试卷头里的年份
\int_new:N \l_ustbexam_year_int
\NewDocumentCommand \Year { m }
{ \int_set:Nn \l_ustbexam_year_int {#1} }

% 试卷头里的学期
\str_new:N \l_ustbexam_semester_str
\NewDocumentCommand \Semester { m }
  { \str_set:Nn \l_ustbexam_semester_str {#1} }

% 试卷头里的课程
\tl_new:N \l__ustbexam_course_tl
\NewDocumentCommand \Course { o m }
  {
    \IfNoValueTF {#1}
      {
        % 默认使用自然宽度
        \hbox_set:Nn \l_tmpa_box {#2}
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box * 2 }
        \tl_set:Nn \l__ustbexam_course_tl
          {
            \__examzh_spread_box:nn { \l_tmpa_dim } {#2}
          }
      }
      {
        % 手动调整宽度
        \tl_set:Nn \l__ustbexam_course_tl
          {
            \__examzh_spread_box:nn {#1} {#2}
          }
      }

    \str_new:N \l__ustbexam_course_str
    \str_set:Nn \l__ustbexam_course_str { #2 }
  }

% 是否期中
\tl_new:N \l_ustbexam_suffix_tl
\NewDocumentCommand \Suffix { m }
  {\tl_set:Nn \l_ustbexam_suffix_tl {#1 试卷} }

% 试卷头里的类型，如A/B/模拟等
\tl_new:N \l_ustbexam_type_tl
\NewDocumentCommand \Type { m }
  { \tl_set:Nn \l_ustbexam_type_tl {
      \bool_if:NTF \l__examzh_question_show_paren_answer_bool
      {\l_ustbexam_suffix_tl （#1 卷解析）}
      {\l_ustbexam_suffix_tl （#1 卷）}
    }
  }

% 试卷头计分表中大题的数目
\int_new:N \l_ustbexam_num_of_sections_int
\NewDocumentCommand \TotalPart { m }
  { \int_set:Nn \l_ustbexam_num_of_sections_int {#1} }

% 标题
\tl_new:N \l_ustbexam_title_tl
\tl_set:Nn \l_ustbexam_title_tl
  {
    \int_eval:n { \l_ustbexam_year_int } -- \int_eval:n {\l_ustbexam_year_int + 1} ~学年\,%
    第 \l_ustbexam_semester_str{} 学期 \l__ustbexam_course_str \l_ustbexam_type_tl\
  }

% PDF 主题信息
\str_new:N \l_ustbexam_pdf_subject_str
\NewDocumentCommand \Subject { m }
  { \str_set:Nn \l_ustbexam_pdf_subject_str {#1} }
% PDF 关键词信息
\str_new:N \l_ustbexam_pdf_keywords_str
\NewDocumentCommand \Keywords { m }
  { \str_set:Nn \l_ustbexam_pdf_keywords_str {#1} }

\AtBeginDocument{%
  \hypersetup{
    pdfinfo={
      Title    = {\l_ustbexam_title_tl},
      Author   = {\@author},
      Subject  = {\l_ustbexam_pdf_subject_str},
      Keywords = {\l_ustbexam_pdf_keywords_str},
    },
    colorlinks = true,
  }
}

% 输出标题
\RenewDocumentCommand \maketitle { }
  {
    \par
    \begin { center }
      \let \footnote \thanks
      {
        \LARGE \bfseries 北京科技大学~ \int_eval:n { \l_ustbexam_year_int } -- \int_eval:n {\l_ustbexam_year_int + 1} ~学年\,%
        第~ \l_ustbexam_semester_str{} ~学期 \par
        \underline{\quad \l__ustbexam_course_tl \quad} \l_ustbexam_type_tl
      }
    \par
    \vspace{1em}
      院(系)~\hrulefill\,
      班级~\hrulefill\,
      姓名~\hrulefill\,
      学号~\hrulefill\,
      考试教室~\hrulefill
    \par
    % \vspace{0.5em}
    \ScoreTable
    \end { center }
    \vspace*{-1em}
    \begin{notice}[label=说明：][label=\arabic*、,labelsep=0pt]
      \item 要求正确地写出主要计算或推导过程，过程有错或只写答案者不得分；
      \item 考场、学院、班、学号、姓名均需写全，不写全的试卷为废卷；
      \item 涂改学号及姓名的试卷为废卷；
      \item 请在试卷上答题，在其他纸张上的解答一律无效.
    \end{notice}
  }

% 输出计分表
\RequirePackage{makecell,tabularx}
% we need LaTeX counters and not expl3 ones because of tabularx two-step process
\newcounter{repeatstart}
\newcounter{repeatcurrent}
\newcounter{repeatlast}

\NewDocumentCommand{\repeatcell}{mm}
 {% #1 = number of repeats
  % #2 = key-value pairs
  \oaheix_repeatcell:nn { #1 } { #2 }
 }

\tl_new:N \l__oaheix_repeatcells_body_tl

\keys_define:nn { oaheix/repeatcells }
 {
  text .code:n = \cs_gset_protected:Nn \__oaheix_repeatcell_text:n { #1 },
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
\NewDocumentCommand \ScoreTable {}{
  \begin{tabularx}{\textwidth}{ |X<{\centering}|*{\l_ustbexam_num_of_sections_int}{X<{\centering}|}*{2}{c|}}
    \hline
      题 \hspace*{1em} 号
      & \repeatcell{\l_ustbexam_num_of_sections_int }{text={\zhnumber{##1}}}
      & 课程考核成绩    \\
    \hline
      得 \hspace*{1em} 分
      & \eline{\int_eval:n { \l_ustbexam_num_of_sections_int + 1 } }
    \\
    \hline
  \end{tabularx}
}

\RequirePackage{siunitx}

\setlength{\parindent}{0em}

\examsetup{
  page = {
    foot-content = {
      \l_ustbexam_title_tl \, 第~\thepage~页 \quad 共~\lastpage@lastpage~页
    },
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
  scoringbox/type = onecolumn,
  symbols/change-frac-style = true,
  symbols/change-dfrac-style = true,
  solution/blank-type = hide,
  solution/show-answer = true,
  solution/label-content = 解,
  question/show-answer = true,
  problem/show-answer = true,
  paren/show-answer = true,
  fillin/show-answer = true,
}

\ExamPrintAnswerSet{
  sealline/show=true,
  paren/show-answer=false,
  paren/show-paren=true,
  fillin/show-answer=false,
  solution/show-solution=false,
  fillin/no-answer-type=none,
}

\NewDocumentEnvironment{analysis}{}
  {\begin{solution}[label-content=解析,blank-type=none]}{\end{solution}}
\RenewDocumentEnvironment{proof}{}
  {\begin{solution}[label-content=证明,blank-type=hide]}{\end{solution}}

\RequirePackage{fixdif}
\newdif{\dif}{\mathrm{d}}

\DeclareMathOperator{\cov}{\operatorname{cov}}
\DeclareMathOperator{\sgn}{\operatorname{sgn}}
\DeclareMathOperator{\grad}{\operatorname{grad}}

\newcommand{\abs}[1]{\left| #1 \right|}

\renewcommand{\Re}{\operatorname{Re}}
\renewcommand{\Im}{\operatorname{Im}}
\renewcommand{\le}{\leqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\ge}{\geqslant}
\renewcommand{\geq}{\geqslant}

\everymath{\displaystyle}

% \AddToHook{package/exam-zh-symbols/before}{%
%   \AtBeginDocument{\let\savedsim=\sim}
% }
% \AddToHook{package/exam-zh-symbols/after}{%
%   \AtBeginDocument{\global\let\sim=\savedsim}
% }
