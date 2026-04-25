\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{event}[2026/04/25 Persian legacy-style class for problem sheets]
\LoadClassWithOptions{article}

\newif\ifevent@showsolutions
\event@showsolutionsfalse
\newif\ifevent@showdate
\event@showdatetrue

\DeclareOption{showsolutions}{\event@showsolutionstrue}
\DeclareOption{hidesolutions}{\event@showsolutionsfalse}
\DeclareOption{showdate}{\event@showdatetrue}
\DeclareOption{hidedate}{\event@showdatefalse}
\ProcessOptions\relax

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{event}{This class requires XeLaTeX}{Compile with xelatex instead of pdflatex.}
\fi

\RequirePackage[a4paper, total={6in, 9.5in}]{geometry}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{keyval}
\RequirePackage{xparse}
\RequirePackage{environ}
\RequirePackage[extrafootnotefeatures]{xepersian}

\hypersetup{colorlinks=true,linkcolor=blue,urlcolor=blue,citecolor=blue}

\newcommand{\event@course}{ریاضیات گسسته}
\newcommand{\event@topic}{}
\newcommand{\event@sheet}{برگه تمرین}
\newcommand{\event@number}{}
\newcommand{\event@title}{}
\newcommand{\event@date}{\today}
\newcommand{\event@datelabel}{تاریخ:}
\newcommand{\event@questionlabel}{سؤال}
\newcommand{\event@solutionlabel}{پاسخ}

\newcommand{\event@fontpath}{fonts/}
\newcommand{\event@textfont}{IRZar.ttf}
\newcommand{\event@boldfont}{IRLotusICEE_Bold.ttf}
\newcommand{\event@italicfont}{IRLotusICEE_Iranic.ttf}
\newcommand{\event@bolditalicfont}{IRLotusICEE_BoldIranic.ttf}
\newcommand{\event@leftlogo}{templates/uni_logo.png}
\newcommand{\event@rightlogo}{templates/eng_logo.png}
\newcommand{\event@logoh}{1.15cm}

\define@key{event}{course}{\renewcommand{\event@course}{#1}}
\define@key{event}{topic}{\renewcommand{\event@topic}{#1}}
\define@key{event}{sheet}{\renewcommand{\event@sheet}{#1}}
\define@key{event}{number}{\renewcommand{\event@number}{#1}}
\define@key{event}{title}{\renewcommand{\event@title}{#1}}
\define@key{event}{date}{\renewcommand{\event@date}{#1}}
\define@key{event}{datelabel}{\renewcommand{\event@datelabel}{#1}}
\define@key{event}{questionlabel}{\renewcommand{\event@questionlabel}{#1}}
\define@key{event}{solutionlabel}{\renewcommand{\event@solutionlabel}{#1}}
\define@key{event}{fontpath}{\renewcommand{\event@fontpath}{#1}}
\define@key{event}{textfont}{\renewcommand{\event@textfont}{#1}}
\define@key{event}{boldfont}{\renewcommand{\event@boldfont}{#1}}
\define@key{event}{italicfont}{\renewcommand{\event@italicfont}{#1}}
\define@key{event}{bolditalicfont}{\renewcommand{\event@bolditalicfont}{#1}}
\define@key{event}{leftlogo}{\renewcommand{\event@leftlogo}{#1}}
\define@key{event}{rightlogo}{\renewcommand{\event@rightlogo}{#1}}
\define@key{event}{logoh}{\renewcommand{\event@logoh}{#1}}

\newcommand{\eventsetup}[1]{\setkeys{event}{#1}}
\newcommand{\showsolutions}{\event@showsolutionstrue}
\newcommand{\hidesolutions}{\event@showsolutionsfalse}
\newcommand{\showdate}{\event@showdatetrue}
\newcommand{\hidedate}{\event@showdatefalse}

\newcommand{\eventapplyfonts}{%
  \IfFileExists{\event@fontpath\event@textfont}{%
    \settextfont[
      Path={\event@fontpath},
      BoldFont={\event@boldfont},
      ItalicFont={\event@italicfont},
      BoldItalicFont={\event@bolditalicfont}
    ]{\event@textfont}
    \setdigitfont[
      Path={\event@fontpath},
      BoldFont={\event@boldfont},
      ItalicFont={\event@italicfont},
      BoldItalicFont={\event@bolditalicfont}
    ]{\event@textfont}
  }{}
}
\AtBeginDocument{\eventapplyfonts}

\setlength{\parskip}{5pt plus 1pt}

\newcommand{\event@maybegraphic}[1]{%
  \IfFileExists{#1}{\includegraphics[height=\event@logoh]{#1}}{}
}

\pagestyle{fancy}
\fancyhf{}
\lhead{\event@maybegraphic{\event@leftlogo}}
\rhead{\event@maybegraphic{\event@rightlogo}}
\chead{\small\bfseries \event@sheet\ifx\event@topic\@empty\else\ -- \event@topic\fi}
\cfoot{\thepage}

\renewcommand{\maketitle}{%
  \setlength{\headheight}{15.2pt}
  \setlength{\headsep}{0.2in}
  \thispagestyle{plain}
  \begin{center}
    \event@maybegraphic{\event@leftlogo}\hfill\event@maybegraphic{\event@rightlogo}
    \par\vspace{0.35em}
    {\Huge \event@course\par}
    \vspace{0.05em}
    {\LARGE \event@sheet\par}
    \ifx\event@topic\@empty\else{\large \event@topic\par}\fi
    \ifx\event@title\@empty\else{\large \event@title\par}\fi
    \ifevent@showdate
      {\large \event@datelabel\ \event@date\par}
    \fi
  \end{center}
}

\newcounter{question}
\renewcommand{\thequestion}{\arabic{question}}

\NewDocumentEnvironment{question}{o}{%
  \refstepcounter{question}
  \vspace{.2in}%
  \noindent\textcolor{blue}{\bfseries \event@questionlabel\ \thequestion.\IfValueT{#1}{ #1}}\par
  \vspace{0.3em}\textcolor{blue}{\hrule}\vspace{.1in}%
  \begin{RTL}
  \raggedleft
  \nopagebreak
}{\par\end{RTL}}

\newenvironment{parts}{\begin{enumerate}[label=\textbf{(\alph*)}]}{\end{enumerate}}

\NewEnviron{solution}{%
  \ifevent@showsolutions
    \vspace{.1in}
    \noindent\textcolor{red}{\bfseries \event@solutionlabel:}\par
    \begin{RTL}
    \raggedleft
    \BODY
    \end{RTL}
    \par
  \fi
}

\newcommand{\resetquestions}{\setcounter{question}{0}}

\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
