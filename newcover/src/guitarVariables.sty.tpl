\author{guitar edition}
\title{nomike's ukulele songbook}
\def\printedicion{
	${nusb_bookname}
}%optional
\def\namelogo{png/guitar.png}
\def\printlogo{\includegraphics[scale=.6]{\namelogo}}
\def\printsongsversion{
	Songs: ${songs_version}
}
\def\printscriptversion{
	Script: ${nusb_version}
}
%\def\printdedication{
%	For my brother
%}%you can delete this def 
%\def\printinitialmessage{
%	God made the integers; all else is the work of man.
%	\begin{flushright}
%		\textbf{Leopold Kronecker.}
%	\end{flushright}
%}%you can delete this def 
%Title in cover personalized
%\AtEndPreamble{
%	\renewcommand{\printcontentcover}{
%		\begin{tcolorbox}[bannerCoverSyle]
%			\hspace{1cm}
%			\includesvg[inkscapelatex=false, scale=0.65]{svg/title.svg}
%			{\color{white}\rule{\paperwidth}{1pt}}
%			\begin{flushright}
%				{\color{white}\huge \textbf{\printedicion}\hspace{7cm}}
%			\end{flushright}	
%		\end{tcolorbox} 
%		\begin{tcolorbox}[bannerLogoCoverSyle, transparent, width = 8cm, flush right]
%			\centering
%			{\includegraphics[scale=.5]{\namelogo}}  
%		\end{tcolorbox}
%	}
%}