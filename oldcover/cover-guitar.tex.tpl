\documentclass[a4paper]{article}
\usepackage{graphicx}
\usepackage{titling}

% set up \maketitle to accept a new item
\predate{\begin{center}\placetitlepicture\large}
\postdate{\par\end{center}}

% commands for including the picture
\newcommand{\titlepicture}[2][]{%
  \renewcommand\placetitlepicture{%
    \includegraphics[#1]{#2}\par\medskip
  }%
}
\newcommand{\placetitlepicture}{} % initialization
\renewcommand{\familydefault}{\sfdefault}

\begin{document}
\Huge
\title{nomike's Ukulele Songbook}
\author{Guitar Edition}
\date{Script: ${nusb_version}\\
Songs: ${songs_version}}
\titlepicture[width=6in]{guitar}

\maketitle
\thispagestyle{empty}

\end{document}
