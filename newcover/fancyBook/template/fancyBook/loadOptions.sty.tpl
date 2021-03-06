\newif{\ifbibunits}
\newif{\ifnotindentall}
\newif{\ifnumeralchapter}
\newif{\ifcoverpagecontent}
\newif{\ifindexmake}
\numeralchaptertrue
\notindentalltrue
\coverpagecontenttrue
\pgfkeys{	
	/DATEMPLATE/.cd,
	compileFrom/.initial= local,
	compileFrom/.get=\compilefrom,
	compileFrom/.store in=\compilefrom,
	bibunits/.is if=bibunits,
	bibliographySource/.initial= references/unionBibliography,
	bibliographySource/.get=\bibliographysrc,
	bibliographySource/.store in=\bibliographysrc,
	bibliographyStyle/.initial= abbrv,
	bibliographyStyle/.get=\bibliographystyletemplate,
	bibliographyStyle/.store in=\bibliographystyletemplate,
	notIndent/.is if=notindentall,
	numeralChapter/.is if=numeralchapter,
	coverpage/.is if=coverpagecontent,
	indexMake/.is if=indexmake,
	theme/.initial= ${newcover_theme_name},
	theme/.get=\themetemplate,
	theme/.store in=\themetemplate,
}