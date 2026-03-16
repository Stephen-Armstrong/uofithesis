\NeedsTeXFormat{LaTeX2e}[2025/11/01]
\ProvidesClass{uofithesis}[2026/03/03 v1.2 University of Illinois Graduate College Dissertation/Thesis Class]

\LoadClass[letterpaper,12pt,oneside]{report}

\RequirePackage[english]{babel}
\RequirePackage{geometry}
\RequirePackage{setspace}
% sectsty is partially compatible with tagging, don't use \sectionrule
\RequirePackage{sectsty}
\RequirePackage{float}
\RequirePackage{fontsetup}

% titlesec is not compatible with tagging according to this issue:
% https://github.com/latex3/tagging-project/issues/24 
% But it is needed to format titles according to Graduate College requirements, so we will use it
\RequirePackage[nostruts,compact,noindentafter]{titlesec}

% pgfplots configuration for accessible color schemes
\RequirePackage{etoolbox}
\AtEndPreamble{
    \@ifpackageloaded{pgfplots}{
        \usepgfplotslibrary{colorbrewer}
        % Qualitative color scheme from https://colorbrewer2.org/
        % Color-blind friendly, adjusted for WCAG AA contrast
        \definecolor{aa-teal}{HTML}{168362}
        \definecolor{aa-orange}{HTML}{C05402}
        \definecolor{aa-blue}{HTML}{716CB2}
        \definecolor{aa-pink}{HTML}{e7298a}

        \pgfplotscreateplotcyclelist{StrictAA}{
            {aa-teal, fill=aa-teal, draw=black},
            {aa-orange, fill=aa-orange, draw=black},
            {aa-blue, fill=aa-blue, draw=black},
            {aa-pink, fill=aa-pink, draw=black}
        }
    }{}
}

% Styles
\titleformat{\chapter}
    [hang]
    {\normalfont\bfseries\fontsize{12pt}{14.4pt}\selectfont\centering}
    {\thechapter}
    {1em}
    {}
    {}
\titlespacing{\chapter}{0em}{-2em}{1em}

\newgeometry{margin=1in}
\allsectionsfont{\normalfont\bfseries\fontsize{12pt}{14.4pt}\selectfont\centering}
\sectionfont{\normalfont\bfseries\fontsize{12pt}{14.4pt}\selectfont\raggedright}
\subsectionfont{\normalfont\bfseries\fontsize{12pt}{14.4pt}\selectfont\raggedright}
\AddToHook{cmd/chapter/before}{\clearpage}

% Options for the title page
\newcommand{\department}[1]{\def\@department{#1}}
\newcommand{\concentration}[1]{\def\@concentration{#1}}
\newcommand{\minor}[1]{\def\@minor{#1}}
\newcommand{\degreeyear}[1]{\def\@degreeyear{#1}}
\newcommand{\committee}[1]{\def\@committee{#1}}
\newcommand{\earneddegree}[1]{\def\@earneddegree{#1}}
\newcommand{\committeetitle}[1]{\def\@committeetitle{#1}}

% Copyright page option
\newif\if@copyrightpage
\@copyrightpagefalse % Default to no copyright page
\newcommand{\copyrightpage}{\@copyrightpagetrue}

\newif\ifdissertation
\dissertationtrue % Default to dissertation
\DeclareOption{thesis}{\dissertationfalse}
\ProcessOptions\relax

\def\@degreetext{Submitted in partial fulfillment of the requirements\\for the degree of}
\def\@degreelevel{}

% Make the title according to Graduate College formatting requirements
\renewcommand{\maketitle}{%
    \if@copyrightpage
    \begin{titlepage}
        \vspace*{\fill}
        \begin{center}
            \textcopyright\ \@degreeyear\ \@author
        \end{center}
        \vspace*{\fill}
    \end{titlepage}
    \fi
    \begin{titlepage}
        \newgeometry{margin=1in,vmargin={1.3in,1in}}
        \linespread{1.2}
        \begin{center}%
            \vbox to 3.5in{%
                \tagstructbegin{tag=Title}
                \tagmcbegin{tag=Title}
                % Disable automatic tagging, otherwise a P gets inserted inside the Title
                \tagpdfsetup{para/tagging=false}

                {\fontsize{12pt}{14.4pt}\selectfont \bfseries \@title}

                \tagpdfsetup{para/tagging=true}
                \tagmcend
                \tagstructend

                \vskip 12pt

                by \par

                \vskip 12pt

                {\@author \par}
                \vfill
            }

            % Set defaults based on dissertation vs thesis
            \ifdissertation
            \ifdefined\@department
            \gdef\@degreelevel{ Doctor of Philosophy in \@department}
            \fi
            \gdef\@thesislabel{Dissertation}
            \gdef\@defaultcommitteetitle{Doctoral Committee:}
            \else
            \ifdefined\@department
            \gdef\@degreelevel{ Master of Science in \@department}
            \fi
            \gdef\@thesislabel{Thesis}
            \gdef\@defaultcommitteetitle{Master's Committee:}
            \fi

            % Use custom earned degree if set, otherwise use default
            \ifdefined\@earneddegree
            \gdef\@degreelevel{ \@earneddegree}
            \fi

            % Use custom committee title if set, otherwise use default
            \ifdefined\@committeetitle\else
            \gdef\@committeetitle{\@defaultcommitteetitle}
            \fi

            {\@thesislabel\par}
            \vspace{12pt}
            \@degreetext
            \@degreelevel\\
            \ifdefined\@concentration
            with a concentration in \@concentration\\
            \fi
            \ifdefined\@minor
            with a minor in \@minor\\
            \fi
            in the Graduate College of the\\
            University of Illinois Urbana-Champaign, \@degreeyear\par
            \vspace{12pt}
            \vbox to 0.4in{%
                {Urbana, Illinois\par}
                \vfill
            }%
        \end{center}%
        \begin{flushleft}
            {\@committeetitle\par}
            \setlength{\leftmargini}{0.5in}
            \begin{itemize}[label={}]
                    \setlength{\itemsep}{0pt}
                    \setlength{\parskip}{0pt}
                    \setlength{\parsep}{0pt}
                    \@committee
            \end{itemize}
        \end{flushleft}
        \par
        \restoregeometry
    \end{titlepage}
}

% Abstract environment
\renewenvironment{abstract}{%
    \thispagestyle{plain}
    \chapter*{Abstract}
    \vspace{12pt}
    \doublespacing
}{%
}

% Acknowledgements environment
\newenvironment{acknowledgements}{%
    \thispagestyle{plain}
    \chapter*{Acknowledgements}
    \vspace{12pt}
    \doublespacing
}{%
}


% Adjust ToC line height
% tableofcontents adds its own spacing on top of line height, hence the 12pt line height
\let\thesis@tableofcontents=\tableofcontents
\def\tableofcontents{{\fontsize{12pt}{12pt}\selectfont\thesis@tableofcontents}}

\renewcommand{\thechapter}{Chapter \arabic{chapter}}
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
% These new renew commands are needed to replace the defaults that the report class sets.
% The report class counts the equation, figure, and table counters within chapters, 
% which adds "Chapter #ChapterNumber" as a prefix to the numbering. 
% The Graduate College formatting requirements specify that these should be numbered sequentially 
% throughout the document without the chapter "Chapter #ChapterNumber" prefix.
\renewcommand{\theequation}{\arabic{equation}}
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}

% Include chapters and sections in the ToC, but exclude subsubsections.
\AtBeginDocument{\setcounter{tocdepth}{1}}
\renewcommand*{\l@chapter}{\@dottedtocline{0}{1.5em}{5em}}
\renewcommand*{\l@section}{\@dottedtocline{1}{3em}{2.5em}}
