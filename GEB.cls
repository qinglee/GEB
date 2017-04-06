
\let \pdfmdfivesum \mdfivesum

\NeedsTeXFormat{LaTeX2e}[2016/01/01]
\RequirePackage{expl3}[2016/01/01]
\ProvidesExplClass{GEB}{2016/10/01}{0}{GEB}

\DeclareOption * { \PassOptionsToClass { \CurrentOption } { ctexbook } }
\PassOptionsToClass { linespread = 4/3 , fontset = none } { ctexbook }
\ProcessOptions \scan_stop:
\LoadClass { ctexbook } [ 2016/10/25 ]

\raggedbottom

\int_zero:N \tex_widowpenalty:D
\int_zero:N \tex_clubpenalty:D
\int_zero:N \tex_displaywidowpenalty:D
\int_zero:N \tex_predisplaypenalty:D
\skip_zero:N \parskip

\RequirePackage { geometry }

\skip_set:Nn \topskip { 12pt }

%\geometry
%  {
%    showcrop ,
%    papersize    = { 146mm , 212.5mm } ,
%    layoutsize   = { 140mm ,   203mm } ,
%    layoutoffset = {   3mm ,  4.75mm }
%  }
\geometry
  {
    papersize     = { 140mm , 203mm } ,
    lines         = 27 ,
    hmargin       = 15mm ,
    bindingoffset =  5mm ,
    headheight    = 10pt ,
    headsep       = \baselineskip ,
    includehead   = true ,
    vcentering    = true
  }

\PassOptionsToPackage { mainaux , starttoc } { rerunfilecheck }
\RequirePackage
  {
    empheq ,
    unicode-math ,
    xfrac ,
    xlop ,
    chngcntr ,
    titleps ,
    enumitem ,
    tabu ,
    multirow ,
    longtable ,
    booktabs ,
    xcolor ,
    rotating ,
    subcaption ,
    floatrow ,
    picinpar ,
    hyperref ,
    bookmark ,
    rerunfilecheck ,
    hyperxmp ,
    tikz ,
  }

%\ctex_patch_cmd:Nnn \pgfutil@InputIfFileExists
%  { \input #1 \relax }
%  {
%    \@pushfilename
%    \xdef \@currname {#1}
%    \input #1 \relax
%    \@popfilename
%  }

\ExplSyntaxOff

\usetikzlibrary
  {
    calc ,
    fit ,
    arrows ,
    matrix ,
    positioning ,
    intersections ,
    arrows.meta ,
    shapes.misc ,
    shapes.geometric ,
    decorations.markings ,
    decorations.pathmorphing ,
    decorations.pathreplacing
  }

\tikzset
  {
    >=Stealth,
    every picture/.style=semithick,
    arrow decoration/.style={
      /tikz/decoration={
        markings,
        mark=at position #1 with {\arrow[xshift=1mm]{Stealth}}
      }
    },
    arrow decoration/.default=.5,
    half left/.style={
      /tikz/bend left=90,
      /tikz/looseness=1.5
    },
    half right/.style={
      /tikz/bend right=90,
      /tikz/looseness=1.5
    },
    fermion/.style={%
      /tikz/arrow decoration,
      /tikz/postaction={
        /tikz/decorate=true
      }
    },
    photon/.style={
      /tikz/draw=none,
      /tikz/decoration={
        complete sines,
        amplitude=1mm,
        segment length=2mm
      },
      /tikz/postaction={
        /tikz/draw,
        /tikz/line join=round,
        /tikz/decorate=true
      }
    },
    fermion edge/.style={
      /tikz/every edge/.style={fermion}
    },
    photon edge/.style={
      /tikz/every edge/.style={photon}
    },
  }

%% Complete sines replaces the path with a whole number of sine waves.
%% Thanks to http://tex.stackexchange.com/a/134516/26980
\pgfdeclaredecoration{complete sines}{initial}
{
  %% Begin by computing the overall path length and find how many sine waves we
  %% can fit in.  Nothing happens beyond the computation.
  \state{initial}[
    width=+0pt,
    next state=move,
    persistent precomputation={
      \def\tikzfeynman@cs@angle@step{30}
      \def\tikzfeynman@cs@current@angle{0}
      \edef\tikzfeynman@cs@points@per@step{\the\dimexpr
        \pgfdecoratedinputsegmentlength
        / \numexpr\dimexpr\pgfdecoratedinputsegmentlength\relax/
                  \dimexpr\pgfdecorationsegmentlength\relax\relax
        / 360
        * \tikzfeynman@cs@angle@step\relax}
    },
  ]{}
  %% Move to the origin to the path
  \state{move}[
    width=+\tikzfeynman@cs@points@per@step,
    next state=draw
  ]{
    \pgfpathmoveto{\pgfpointorigin}
  }
  %% Draw the sine wave itself.  This computes the value every 30 degrees and draws straight edges.
  \state{draw}[
    width=+\tikzfeynman@cs@points@per@step,
    switch if less than=1.25*\tikzfeynman@cs@points@per@step to final, % <- bit of a hack
    persistent postcomputation={
      \pgfmathmod{\tikzfeynman@cs@current@angle+\tikzfeynman@cs@angle@step}{360}
      \let\tikzfeynman@cs@current@angle=\pgfmathresult
    },
  ]{
    \pgfmathsin{\tikzfeynman@cs@current@angle}
    \dimen@=\pgfdecorationsegmentamplitude\relax
    \dimen@=\dimexpr\pgfmathresult\dimen@/2\relax
    \tikz@decoratepathfalse
    \pgfpathlineto{\pgfqpoint{0pt}{\dimen@}}
  }
  \state{final}{
    \ifdim\pgfdecoratedremainingdistance>\z@
      \pgfpathlineto{\pgfpointdecoratedpathlast}
    \fi
  }
}

\ExplSyntaxOn

%\tl_new:N \g_@@_art_box_tl
%\tl_new:N \g_@@_crop_box_tl
%\tl_gset:Nn \g_@@_art_box_tl
%  {
%    \dim_to_decimal_in_bp:n { \l_@@_left_margin_dim } ~
%    \dim_to_decimal_in_bp:n { \l_@@_bottom_margin_dim + \Gm@bmargin } ~
%    \dim_to_decimal_in_bp:n { \l_@@_left_margin_dim + \textwidth } ~
%    \dim_to_decimal_in_bp:n
%      { \l_@@_bottom_margin_dim + \Gm@bmargin + \textheight }
%  }
%\tl_gset:Nn \g_@@_crop_box_tl
%  {
%    \dim_to_decimal_in_bp:n { \Gm@layouthoffset } ~
%    \dim_to_decimal_in_bp:n { \l_@@_bottom_margin_dim } ~
%    \dim_to_decimal_in_bp:n { \Gm@layouthoffset + \Gm@layoutwidth } ~
%    \dim_to_decimal_in_bp:n { \paperheight - \Gm@layoutvoffset }
%  }
%\cs_new_protected_nopar:Npn \@@_page_attribute:
%  {
%    \AtBeginShipoutAddToBox
%      {
%        \dim_set:Nn \l_@@_left_margin_dim
%          {
%            \hoffset + 1in
%            \int_if_odd:nTF { \value { page } }
%              { + \oddsidemargin }
%              { + \evensidemargin }
%          }
%        \dim_set:Nn \l_@@_bottom_margin_dim
%          { \paperheight - \Gm@layoutvoffset - \Gm@layoutheight }
%        \exp_args:Nx \@@_page_attribute:n
%          {
%            /CropBox [ \g_@@_crop_box_tl ]
%            /ArtBox  [ \g_@@_art_box_tl ]
%%            /Group << /S /Transparency /CS /DeviceRGB /I ~ true>>
%          }
%      }
%  }
%\dim_new:N \l_@@_left_margin_dim
%\dim_new:N \l_@@_bottom_margin_dim
%\cs_new_protected:Npn \@@_page_attribute:n #1
%  { \tex_special:D { pdf: put @thispage << /Type /Page #1 >> } }
%\AtBeginShipout { \@@_page_attribute: }

\tl_const:Nn \c_@@_title_tl  { 歌德尔、艾舍尔、巴赫——集异壁之大成 }
\tl_const:Nn \c_@@_author_tl { 侯世达 }

\hypersetup
  {
    hidelinks ,
    hypertexnames      = true ,
    naturalnames       = false ,
    pdfstartview       = XYZ ~ null ~ null ~ 1 ,
    pdfpagemode        = UseNone ,
    pdfpagelayout      = TwoPageRight ,
    pdfprintscaling    = None ,
    pdfduplex          = DuplexFlipLongEdge ,
    pdfdisplaydoctitle = true ,
    pdflang            = zh-CN ,
    pdfcopyright       = { 版权所有 \ \textcopyright \ 商务印书馆\textCR
                           所有权利保留。\textCR
                           未经许可，不得以任何方式使用。 } ,
    pdflicenseurl      = http://www.cp.com.cn/ ,
    baseurl            = http://www.cp.com.cn/book/7-100-01323-2_41.html ,
    pdfcontacturl      = http://www.cp.com.cn/service/contact.html ,
    pdfauthortitle     = 美国印第安纳大学文理学院认知科学和计算机科学杰出教授 ,
    pdfinfo            =
      {
        Title    = \c_@@_title_tl ,
        Author   = \c_@@_author_tl ,
        Subject  =
          {
            集异璧——GEB，是数学家哥德尔、版画家艾舍尔、音乐家巴赫三人名字的前缀。本书通过对哥德尔的数理逻辑，艾舍尔的版画和巴赫的音乐三者的综合阐述，引人入胜地介绍了数理逻辑学、可计算理论、人工智能学、语言学、遗传学、音乐、绘画的理论等方面，构思精巧、含义深刻、视野广阔、富于哲学韵味。\textCR
            本书在英语世界中有极高评价，曾获得普利策文学奖。该中译本前后费时十余年，译者都是数学和哲学的专家，还得到原作者的直接参与，译文严谨通达，特别是在原作者的帮助下，把西方的文化典故和说法，尽可能转换为中国文化的典故和说法，使这本译本甚至可看作是一部新的创作，也是中外翻译史上的一个创举。
          } ,
        Keywords = { 哥德尔 , ~ 艾舍尔 , ~ 巴赫 } ,
        Creator = XeLaTeX ~ + ~ xeCJK ~ + ~ CTeX ,
      } ,
  }

\use:x
  {
    \ctex_patch_cmd:Nnn \exp_not:N \hyxmp@text@resource
      { \c_right_brace_str \c_space_tl }
      { \c_right_brace_str }
  }

\bookmarksetup
  {
    open      = true ,
    numbered  = true ,
    depth     = subparagraph ,
    openlevel = \toclevel@chapter ,
  }

\ctex_preto_cmd:NnnTF \__um_remap_symbols: { }
  { \@@_remap_symbols: }
  { }
  { \ctex_patch_failure:N \__um_remap_symbols: }

\cs_new_protected_nopar:Npn \@@_remap_symbols:
  {
    \__um_remap_symbol:nnn { `\＜ } { \mathopen }  { "027E8 } %% \langle
    \__um_remap_symbol:nnn { `\＞ } { \mathclose } { "027E9 } %% \rangle
    \__um_remap_symbol:nnn { `\～ } { \mathord }   { "0223C } %% \sim
    \__um_assign_delcode:nn { `\＜ } { "027E8 }
    \__um_assign_delcode:nn { `\＞ } { "027E9 }
  }

\unimathsetup
  {
    colon = literal ,
    warnings-off = mathtools-colon
  }

\xeCJKsetup
  {
    AllowBreakBetweenPuncts = true ,
    CheckSingle             = true ,
    AutoFakeBold            = false ,
    AutoFakeSlant           = false ,
    CheckFullRight          = true ,
    PunctStyle              = kaiming ,
    KaiMingPunct+           = ：； ,
    NewLineCS+              = \item
  }

\setmainfont { TeX ~ Gyre ~ Termes }
\setsansfont { TeX ~ Gyre ~ Heros }
\setmonofont { TeX ~ Gyre ~ Cursor }
\setmathfont { TeX ~ Gyre ~ Termes ~ Math }
\newfontfamily \Palatino  [ Ligatures = TeX ] { TeX ~ Gyre ~ Pagella }
\newfontfamily \Cyrillic  [ Ligatures = TeX ] { FreeSerif }

\DeclareTextFontCommand { \textcyr } { \Cyrillic }

\NewDocumentCommand \MakeMinusOrd { }
  { \__um_set_mathcode:nnnn { `\- } { \mathord } { operators } { "02212 } }
\NewDocumentCommand \MakeMinusBin { }
  { \__um_set_mathcode:nnnn { `\- } { \mathbin } { operators } { "02212 } }

\cs_new_protected_nopar:Npn \@@_math_alphabet:Nnnn #1#2#3#4
  {
    \cs_undefine:N #1
    \DeclareMathAlphabet #1 { \encodingdefault } {#2} {#3} {#4}
    \cs_if_free:cF
      { \encodingdefault / #2 / \bfdefault / #4 }
      {
        \SetMathAlphabet #1 { bold }
          { \encodingdefault } {#2} { \bfdefault } {#4}
      }
  }
\cs_new_protected_nopar:Npn \@@_math_alphabet_aux:nnnn #1#2#3#4
  {
    \use:x
      {
        \@@_math_alphabet:Nnnn
          { \exp_not:c { mathtext #1 } }
          { \use:c { #2 default } }
          { \use:c { #3 default } }
          { \use:c { #4 default } }
      }
  }
\clist_map_inline:nn
  {
    { rm } { rm } { md } { up } ,
    { it } { rm } { md } { it } ,
    { bf } { rm } { bf } { up } ,
    { sf } { sf } { md } { up } ,
    { tt } { tt } { md } { up } ,
  }
  { \@@_math_alphabet_aux:nnnn #1 }

%\DeclareSymbolFont { mathsans }
%  { \g_fontspec_encoding_tl }
%  { \g__fontspec_mathsf_tl }
%  { \mddefault }
%  { \updefault }
%\SetSymbolFont { mathsans } { bold }
%  { \g_fontspec_encoding_tl }
%  { \g__fontspec_mathsf_tl }
%  { \bfdefault }
%  { \updefault }
%\DeclareSymbolFontAlphabet \mathsf { mathsans }%
%\tl_const:Nn \c_@@_mathsans_letter_tl
%  { W J U P Q R Z d t p q }
%\bool_new:N \l_@@_mathsans_bool
%\cs_new_nopar:Npn \@@_set_mathcode:N #1
%  {
%    \utex_mathcode:D \int_eval:n { `#1 } =
%      \c_two \symmathsans ~ \int_eval:n { `#1 } ~
%  }
%\cs_new_nopar:Npn \@@_reset_mathcode:N #1
%  {
%    \utex_mathcodenum:D \int_eval:n { `#1 } =
%      \exp_not:N \tex_the:D \utex_mathcodenum:D \int_eval:n { `#1 } ~ \c_space_tl
%  }
%\cs_new_protected_nopar:Npn \ResetSansLetter
%  { }
%\cs_new_protected_nopar:Npx \MakeSansLetter
%  {
%    \exp_not:N \bool_if:NF \l_@@_mathsans_bool
%      {
%        \cs_set_protected_nopar:Npx \ResetSansLetter
%          {
%            \tl_map_function:NN \c_@@_mathsans_letter_tl \@@_reset_mathcode:N
%            \bool_set_false:N \l_@@_mathsans_bool
%            \cs_set_protected:Npn \ResetSansLetter { }
%          }
%      }
%    \tl_map_function:NN \c_@@_mathsans_letter_tl \@@_set_mathcode:N
%    \bool_set_true:N \l_@@_mathsans_bool
%  }

\setCJKmainfont
  [
      BoldFont = FZYaSong-DB1-GBK,
    ItalicFont = FZNewKai_GB18030-Z03
  ] { FZNewShuSong_GB18030-Z10 }
\setCJKsansfont [ BoldFont = FZYouH_510M ] { FZYouH_508R }
\setCJKmonofont { FZFangSong-Z02_GB18030 }
\newCJKfontfamily \KAISHU   { FZNewKai_GB18030-Z03 }
\newCJKfontfamily \FANGSONG { FZFangSong-Z02_GB18030 }

\ctex_set_font_size:Nnn \normalsize { 5 }
  {
    \skip_zero:N \abovedisplayshortskip
    \skip_set_eq:NN \abovedisplayskip \medskipamount
    \skip_set_eq:NN \belowdisplayskip \abovedisplayskip
    \skip_set_eq:NN \belowdisplayshortskip \belowdisplayskip
  }
\ctex_set_font_size:Nnn \small { -5 }
  {
    \skip_zero:N \abovedisplayshortskip
    \skip_set_eq:NN \abovedisplayskip \smallskipamount
    \skip_set_eq:NN \belowdisplayskip \abovedisplayskip
    \skip_set_eq:NN \belowdisplayshortskip \belowdisplayskip
  }
\ctex_set_font_size:Nnn \footnotesize { 6 }
  {
    \skip_zero:N \abovedisplayshortskip
    \skip_set:Nn \abovedisplayskip { \smallskipamount / 2 }
    \skip_set_eq:NN \belowdisplayskip \abovedisplayskip
    \skip_set_eq:NN \belowdisplayshortskip \belowdisplayskip
  }

\RenewDocumentCommand \em { }
  {
    \@nomath \em
    \sffamily \bfseries
  }

\NewDocumentCommand \inst { m }
  {
    \mode_if_math:TF
      { \text }
      { \use:n }
      { \textsf {#1} }
  }

\NewDocumentCommand \CELL { }
  { \inst { CELL } }

\NewDocumentCommand \kaishu { }
  { \KAISHU \Palatino }
\NewDocumentCommand \fangsong { }
  { \FANGSONG \Chaparral }
\NewDocumentCommand \quotefont { }
  { \kaishu }

\setcounter { secnumdepth } { 0 }
\setcounter { tocdepth } { 0 }

\ctexset
  {
    part    = {
      break       = \cleardoublepage ,
      pagestyle   = empty ,
      fixskip     = true ,
      name        = { , 篇 } ,
      number      = \shangxia { part } ,
      nameformat  = \ziju { 1 } \Large ,
      aftertitle  = \par \includepartgraphics ,
      aftername   = \par \nointerlineskip \tex_vfill:D ,
      beforeskip  = \fill ,
      afterskip   = \fill ,
    } ,
    chapter = {
      break       = \clearpage ,
      pagestyle   = empty ,
      fixskip     = true ,
      format      = \centering \bfseries \LARGE
                    \@@_endnote_chapter: ,
      tocline     = \CTEXnumberline {#1} #2 ,
      beforeskip  = \bigskipamount * 2 ,
      afterskip   = \bigskipamount * 2 ,
      lofskip     = \c_zero_skip ,
      lotskip     = \c_zero_skip ,
    } ,
    section = {
      fixskip     = true ,
      hang        = false ,
      format      = \@@_topskip_kludge:n { section }
                    \centering \sffamily \bfseries \Large ,
      beforeskip  = \baselineskip + \smallskipamount ,
      afterskip   = \baselineskip + \smallskipamount ,
    } ,
    subsection= {
      fixskip     = true ,
      hang        = false ,
      format      = \centering \sffamily \bfseries ,
      beforeskip  = \bigskipamount ,
      afterskip   = \bigskipamount ,
    } ,
    bibname        = 文献目录 ,
    listfigurename = 插图目录 ,
  }

\cs_new_protected_nopar:Npn \@@_topskip_kludge:n #1
  {
    \skip_set:Nn \l_tmpa_skip
      { \l_@@_headsep_dim - ( \use:c { CTEX@#1@afterskip } ) }
    \dim_compare:nNnTF { \l_tmpa_skip } > \c_zero_dim
      { \skip_set_eq:NN \l_tmpa_skip \topskip }
      { \skip_add:Nn \l_tmpa_skip { \topskip } }
    \skip_vertical:N \l_tmpa_skip
    \@vspacer { -\l_tmpa_skip }
  }

\cs_new_protected_nopar:Npn \@@_strut:n #1
  {
    \hbox_set:Nn \l_tmpa_box { }
    \box_set_ht:Nn \l_tmpa_box {#1}
    \box_use_clear:N \l_tmpa_box
  }

\cs_new_nopar:Npn \shangxia #1
  { \@shangxia { \value {#1} } }
\cs_new_nopar:Npn \@shangxia #1
  {
    \int_to_symbols:nnn {#1} { 2 }
      {
        { 1 } { 上 }
        { 2 } { 下 }
      }
  }

\NewDocumentEnvironment { intro } { }
  {
    \setcounter { chapter } { -1 }
    \ctexset { chapter/name , chapter/number = 导言 }
    \chapter
  }
  { }

\NewDocumentEnvironment { dialog } { }
  {
    \ctexset
      {
        chapter/numbering  = false ,
        chapter/format     = \kaishu \centering \LARGE
                             \@@_put_heading_box:
                             \@@_endnote_chapter: ,
        chapter/beforeskip = \baselineskip ,
        chapter/afterskip  = \baselineskip
      }
    \chapter
  }
  { }

\box_new:N \headingbox
\box_new:N \TEMPBOX

\cs_new_protected_nopar:Npn \@@_put_heading_box:
  {
    \box_if_empty:NF \headingbox
      { \@@_put_heading_box_aux: }
  }
\cs_new_protected_nopar:Npn \@@_put_heading_box_aux:
  {
    \skip_set:Nn \l_tmpa_skip { \CTEX@chapter@beforeskip }
    \skip_if_eq:nnTF \l_tmpa_skip \c_zero_skip
      { \use_i:nn }
      {
        \skip_vertical:n { -\l_tmpa_skip }
        \use:nn
      }
      {
        \noindent \box_use_clear:N \headingbox
        \par \nointerlineskip
      }
      { \skip_vertical:N \l_tmpa_skip }
  }
\RenewDocumentCommand \descriptionlabel { m }
  { \normalfont #1 }

\skip_zero:N \partopsep
\skip_set_eq:NN \topsep \smallskipamount

\setlist { nosep , topsep = \smallskipamount , labelsep = .5em }
\setlist [ enumerate , 1 ]
  {
    label = ( \arabic * ) ,
    labelindent = \parindent ,
    leftmargin  = *
  }
\setlist [ itemize , 1 ]
  {
    labelindent = \parindent ,
    leftmargin  = *
  }
\setlist [ description , 1 ]
  {
    labelindent = \parindent ,
    leftmargin  = *
  }

\cs_new_protected_nopar:Npn \FixItemIndent
  {
    \box_if_empty:NF \@labels
      {
        \hbox_set:Nn \@labels
          {
            \box_set_wd:Nn \@labels { \c_zero_dim }
            \box_use_clear:N \@labels
          }
      }
  }

\newlist { dialogue } { description } { 5 }
\setlist [ dialogue ]
  {
    labelsep   = \ccwd ,
    labelwidth = \l_@@_name_width_tl ,
    leftmargin = \dim_eval:n { \labelwidth + \labelsep } ,
    align   = fillleft ,
    topsep  = \medskipamount ,
    format  = \@@_name_colon:n
  }
\setlist [ dialogue , 1 ] { topsep  = \bigskipamount }
\cs_new_protected_nopar:Npn \@@_name_colon:n #1
  {
    \tl_if_empty:nF {#1}
      { \sffamily #1 \hbox_overlap_right:n { ： } }
  }

\NewDocumentCommand \itemcolon { m }
  {
    \tl_if_empty:nF {#1}
      { #1 \hbox_overlap_right:n { ： } }
  }
\cs_new_protected_nopar:Npn \@@_speculation_item:n #1
  {
    \int_gincr:N \g_@@_speculation_int
    \tl_if_empty:nF {#1}
      {
        \sffamily
        \int_if_odd:nF { \g_@@_speculation_int }
          { \tex_kern:D 2\ccwd }
        #1
        \hbox_overlap_right:n { ： }
      }
  }
\SetEnumitemKey { speculation }
  {
    labelsep   = \ccwd ,
    labelwidth = 2\ccwd ,
    leftmargin = 3\ccwd ,
    align   = fillleft ,
    topsep  = \medskipamount ,
    format  = \@@_speculation_item:n ,
    before  = \int_gzero:N \g_@@_speculation_int
              \cs_set_eq:NN \@item \speculation@item
  }
\int_new:N \g_@@_speculation_int
\cs_new_eq:NN \speculation@item \@item
\ctex_patch_cmd:Nnn \speculation@item
  { \addvspace \itemsep }
  { \speculation@additemsep }
\cs_new_protected_nopar:Npn \speculation@additemsep
  {
    \int_if_odd:nTF { \g_@@_speculation_int }
      { \addvspace \itemsep }
      { \addvspace { \skip_eval:n { \itemsep + \topsep } } }
  }

\SetLabelAlign { fillleft }
  { \tex_hfill:D #1 }
\SetLabelAlign { fillright }
  { #1 \tex_hfill:D }

\NewDocumentCommand \setnamewidth { }
  { \tl_set:Nn \l_@@_name_width_tl }
\tl_new:N \l_@@_name_width_tl
\tl_set:Nn \l_@@_name_width_tl { 4\ccwd }

\NewDocumentCommand \bn { }
  { \textit }

\ctex_patch_cmd:Nnn \cleardoublepage
  { \newpage }
  { \thispagestyle { empty } \newpage }

\NewDocumentCommand \covermatter { }
  {
    \pagestyle { empty }
    \pagenumbering { Alph }
  }

\RenewDocumentCommand \frontmatter { }
  {
    \cleardoublepage
    \@mainmatterfalse
    \ctexset { chapter/numbering = false }
    \pagestyle { front }
    \pagenumbering { front }
  }

\cs_new_nopar:Npn \@front #1
  { \frontpage { \int_eval:n {#1} } }

\NewDocumentCommand \frontpage { m }
  { \textit {#1} }

\cs_new_nopar:Npn \pdf@frontpage #1
  { [ #1 ] }
\pdfstringdefDisableCommands
  { \let \frontpage \pdf@frontpage }

\RenewDocumentCommand \mainmatter { }
  {
    \addtocontents { toc } { \tocmainmatter }
    \cleardoublepage
    \@mainmattertrue
    \bookmarksetup { startatroot }
    \ctexset { chapter/numbering = true }
    \pagestyle { main }
    \pagenumbering { arabic }
  }


\RenewDocumentCommand \backmatter { }
  {
    \addtocontents { toc } { \tocbackmatter }
    \cleardoublepage
    \@mainmatterfalse
    \bookmarksetup { startatroot }
    \ctexset { chapter/numbering = true }
  }

\newpagestyle { front } [ \small ]
  {
    \sethead
      [ \quad \thepage ]
      [ \c_@@_title_tl ]
      [ ]
      { }
      { \chaptertitle }
      { \thepage \quad }
    \cs_set_eq:NN \makeheadrule \@@_head_rule:
  }
\newpagestyle { main } [ \small ]
  {
    \sethead
      [ \quad \thepage ]
      [ \c_@@_title_tl ]
      [ \ifthechapter { \CTEXthechapter } { } ]
      { \chaptertitle }
      { }
      { \thepage \quad }
    \cs_set_eq:NN \makeheadrule \@@_head_rule:
  }
\cs_new_protected_nopar:Npn \@@_head_rule:
  { \box_use:N \l_@@_head_rule_box }
\box_new:N \l_@@_head_rule_box
\vbox_set_top:Nn \l_@@_head_rule_box
  {
    \skip_vertical:N \medskipamount
    \tex_hrule:D width \textwidth height .8pt depth \c_zero_dim \scan_stop:
  }
\pagestyle { main }

\dim_new:N \l_@@_headsep_dim
\dim_set:Nn \l_@@_headsep_dim
  {
    \headsep - \box_ht:N \l_@@_head_rule_box
             - \box_dp:N \l_@@_head_rule_box
  }

\NewDocumentEnvironment { thebib } { }
  {
    \ctexset { chapter/numbering = false }
    \chapter { \bibname }
    \footnotesize
  }
  { \par }

\NewDocumentCommand \includepartgraphics { }
  {
    \exp_args:NNf \prop_get:NnNTF \g_@@_part_graphics_prop
      { \arabic { part } } \l_tmpa_tl
      { \exp_after:wN \@@_part_graphics:nn \l_tmpa_tl }
      { }
  }
\prop_new:N \g_@@_part_graphics_prop
\prop_gput:Nnn \g_@@_part_graphics_prop { 1 }
  { { part1.jpg } { “集异璧”（GEB）三字件在三个互相垂直的方向上的投影。 } }
\prop_gput:Nnn \g_@@_part_graphics_prop { 2 }
  { { part2.jpg } { “异集璧”（EGB）三字件在三个互相垂直方向上的投影。 } }
\cs_new_protected_nopar:Npn \@@_part_graphics:nn #1#2
  {
    \tex_vfill:D
    \addtocontents { lof }
      {
        \token_to_str:N \lofpart { \CTEXthepart }
          {#2} { \thepage } { \@currentHref }
      }
    \includegraphics [ width = .6\linewidth ] {#1}
    \par
  }

\NewDocumentCommand \lofpart { m m m m }
  {
    \item [#1] \indent \@@_hyper_link:nn {#4} {#2}
    \skip_vertical:N \itemsep
  }

\cs_new_protected_nopar:Npn \@@_hyper_link:nn
  { \hyper@link { link } }
\cs_new_protected_nopar:Npn \@@_hyper_anchor:n #1
  { \Hy@raisedlink { \hyper@anchor {#1} } }

\RenewDocumentEnvironment { quote } { O { \small } }
  {
    \list { }
      {
        \skip_zero:N \partopsep
        \skip_set_eq:NN \topsep \smallskipamount
        \skip_set_eq:NN \parsep \parskip
        \dim_zero:N \rightmargin
        \dim_set_eq:NN \leftmargin \parindent
        \group_begin: \quotefont #1 \scan_stop:
          \exp_args:NNNo \group_end:
        \dim_set:Nn \listparindent { \dim_use:N \parindent }
        \skip_set_eq:NN \enit@outerparindent \listparindent
        \mode_if_vertical:TF
          { \dim_set_eq:NN \itemindent \listparindent }
          { \dim_zero:N \itemindent }
      }
    \quotefont #1 \scan_stop:
    \item \scan_stop:
  }
  { \endlist }

\NewDocumentEnvironment { block } { }
  {
    \list { }
      {
        \dim_compare:nNnF \parindent > \c_zero_dim
          { \dim_set:Nn \parindent { 2\ccwd } }
        \skip_zero:N \partopsep
        \skip_set_eq:NN \topsep \smallskipamount
        \skip_set_eq:NN \parsep \parskip
        \dim_zero:N \rightmargin
        \dim_set_eq:NN \leftmargin \parindent
        \dim_set_eq:NN \listparindent \parindent
        \mode_if_vertical:TF
          { \dim_set_eq:NN \itemindent \listparindent }
          { \dim_zero:N \itemindent }
      }
    \obeylines
    \item \scan_stop:
  }
  { \endlist }

\RenewDocumentEnvironment { quotation } { O { \small } }
  {
    \list { }
      {
        \skip_zero:N \partopsep
        \skip_set_eq:NN \topsep \smallskipamount
        \skip_set_eq:NN \parsep \parskip
        \dim_set_eq:NN \leftmargin \parindent
        \dim_set_eq:NN \rightmargin \leftmargin
        \group_begin: #1 \scan_stop:
          \exp_args:NNNo \group_end:
        \dim_set:Nn \listparindent { \dim_use:N \parindent }
        \mode_if_vertical:TF
          { \dim_set_eq:NN \itemindent \listparindent }
          { \dim_zero:N \itemindent }
      }
    #1 \scan_stop:
    \item \scan_stop:
  }
  { \endlist }

\RenewDocumentEnvironment { verse } { O { 1 } }
  {
    \list { }
      {
        \skip_zero:N \partopsep
        \skip_set_eq:NN \topsep \medskipamount
        \skip_set_eq:NN \parsep \parskip
        \dim_set:Nn \itemindent { - \int_eval:n {#1} \ccwd }
        \dim_set_eq:NN \listparindent \itemindent
        \dim_set:Nn \leftmargin { \int_eval:n { (#1) *2 } \ccwd }
        \dim_zero:N \rightmargin
      }
    \quotefont
    \xobeylines
    \cs_set_eq:NN \\ \@@_verse_cr:w
    \item \scan_stop:
  }
  { \endlist }
\group_begin:
  \cs_set:Npn \@@_temp:w #1
    {
      \tl_const:Nn \c_@@_active_cr_tl { #1 }
      \cs_new_protected_nopar:Npn \xobeylines
        {
          \char_set_catcode_active:n { 13 }
          \cs_set_protected_nopar:Npn #1 { \par }
        }
      \NewDocumentCommand \@@_verse_cr:w { o t #1 }
    }
  \int_set_eq:NN \tex_endlinechar:D \c_minus_one
  \char_set_catcode_active:n { 13 }
\exp_after:wN \group_end: \@@_temp:w { ^^M }
  {
    \par
    \IfNoValueTF {#1}
      { \noindent }
      {
        \group_begin:
          \dim_set:Nn \parindent { #1\ccwd }
          \indent
        \group_end:
      }
    \tex_ignorespaces:D
  }

\NewDocumentEnvironment { zenkoan } { }
  { \quote \xobeylines }
  { \endquote }

\NewDocumentCommand \pagemark { m }
  {
    \thispdfpagelabel {#1}
    \AtBeginShipoutNext
      {
        \AtBeginShipoutAddToBox
          { \bookmark [ page = \arabic { abspage } ] {#1} }
      }
  }

\NewDocumentCommand \background { +m }
  { \AtBeginShipoutNext { \AtBeginShipoutUpperLeft {#1} } }

\cs_new_nopar:Npn \circedctr #1
  { \circednum { \int_eval:n { \value {#1} } } }
\NewDocumentCommand \circednum { m }
  {
    \group_begin:
      \circednumfont
      \makexeCJKinactive
      \exp_args:Nf \textcircled { \int_eval:n {#1} }
    \group_end:
  }
\cs_new_eq:NN \@circedctr \circednum
\newfontfamily \circednumfont
  { Kozuka ~ Mincho ~ Pr6N }

\AddEnumerateCounter * { \circedctr } { \circednum } { 1 }

\NewDocumentCommand \lnote { m }
  { #1 }
%  { \group_begin: \small #1 \group_end: }

\NewDocumentCommand \dnote { m }
  { \group_begin: \kaishu #1 \group_end: }

\NewDocumentCommand \dlnote { m }
  { \group_begin: \kaishu #1 \group_end: }

\NewDocumentEnvironment { signature } { O { c } }
  {
    \skip_set_eq:NN \topsep \bigskipamount
    \cs_set_eq:NN \@beginparpenalty \c_ten_thousand
    \tl_set:Nn \arraystretch { 1 }
    \cs_set_eq:NN \extrarowheight \c_zero_dim
    \flushright
    \tabular { @ { } #1 @ { \qquad } }
    \kaishu \ziju { .5 }
  }
  {
    \endtabular
    \endflushright
  }

\newlist { authorlist } { description } { 1 }
\setlist [ authorlist ]
  {
    labelsep    =  \ccwd ,
    labelindent = 2\ccwd ,
    labelwidth  = 3\ccwd ,
    leftmargin  = 6\ccwd ,
    before = \kaishu ,
    format = \kaishu ,
    align  = author ,
    topsep = \medskipamount
  }
\SetLabelAlign { author }
  {
    \int_set_eq:NN \hbadness \c_max_int
    \hbox_to_wd:nn { \labelwidth } {#1}
  }

\newlist { overview } { description } { 1 }
\setlist [ overview ]
  {
    labelsep   = \ccwd ,
    leftmargin = \parindent ,
    before  = \kaishu ,
    format  = \bfseries \sffamily ,
    topsep  = \medskipamount ,
    itemsep = \medskipamount ,
  }

\newlist { biblist } { description } { 1 }
\setlist [ biblist ]
  {
    labelsep    = .2em ,
    labelindent = -\labelsep ,
    leftmargin  = \parindent ,
    align   = right ,
    topsep  = 2\baselineskip ,
    itemsep = \smallskipamount ,
    before  = \sloppy ,
  }

\NewDocumentCommand \quotetext { m }
  { #1 }

\cs_new_eq:NN \@@_saved_contentsline:nnnn \contentsline
\RenewDocumentCommand \contentsline { m }
  {
    \cs_if_exist_use:cF { @@_toc_#1:nnn }
      { \@@_saved_contentsline:nnnn {#1} }
  }
\cs_new_protected_nopar:Npn \@@_toc_part:nnn
  {
    \int_compare:nNnTF { \value { tocdepth } } > { -2 }
      { \@@_toc_part_aux:nnn }
      { \use_none:nnn }
  }
\NewDocumentCommand \tocmainmatter { }
  {
    \addvspace { \bigskipamount }
    \cs_set_eq:NN \@@_toc_chapter_aux:nnn \@@_toc_chapter_check:nnn
  }
\NewDocumentCommand \tocbackmatter { }
  {
    \addvspace { \bigskipamount }
    \cs_set_eq:NN \@@_toc_chapter_aux:nnn \@@_toc_chapter_nocheck:nnn
  }
\cs_new_protected:Npn \@@_toc_part_aux:nnn #1#2#3
  {
    \addpenalty { \@secpenalty }
    \nointerlineskip
    \addvspace { \bigskipamount }
    \group_begin:
      \centering \bfseries \large
      \@@_hyper_link:nn {#3} { \@@_strut:n { \baselineskip } #1 } \par
    \group_end:
    \nobreak \bigskip
  }
\cs_new_protected_nopar:Npn \@@_toc_chapter:nnn
  {
    \int_compare:nNnTF { \value { tocdepth } } > \c_minus_one
      { \@@_toc_chapter_aux:nnn }
      { \use_none:nnn }
  }
\cs_new_protected:Npn \@@_toc_chapter_nocheck:nnn #1#2#3
  {
    \group_begin:
      \sffamily
      \skip_set:Nn \tex_leftskip:D { 2\ccwd }
      \dim_set:Nn \tex_parindent:D { -\tex_leftskip:D }
      \skip_set:Nn \tex_rightskip:D { 6\ccwd plus 1fil minus 3\ccwd }
      \skip_sub:Nn \tex_parfillskip:D { \tex_rightskip:D }
      \int_set_eq:NN \tex_interlinepenalty:D \c_ten_thousand
      \tex_indent:D
      \@@_hyper_link:nn {#3} {#1}
      \tex_penalty:D \c_zero \null \@@_cdot_fill:
      \@@_hyper_link:nn {#3} { { \normalfont #2 } }
      \par
    \group_end:
  }
\cs_new_eq:NN \@@_toc_chapter_aux:nnn \@@_toc_chapter_nocheck:nnn
\cs_new_protected:Npn \@@_toc_chapter_check:nnn #1
  { \@@_toc_chapter_check_aux:w #1 \numberline { } \numberline \q_stop }
\cs_new_protected:Npn \@@_toc_chapter_check_aux:w
  #1 \numberline #2 #3 \numberline #4 \q_stop
  {
    \tl_if_empty:nTF {#1}
      { \@@_toc_chapter:nnnn {#2} {#3} }
      { \@@_toc_dialog:nnn {#1} }
  }
\cs_new_protected:Npn \@@_toc_chapter:nnnn #1#2#3#4
  {
    \group_begin:
      \sffamily
      \hbox_set:Nn \l_tmpa_box { #1 \tex_unskip:D \quad }
      \skip_set:Nn \tex_leftskip:D { \box_wd:N \l_tmpa_box }
      \dim_set:Nn \tex_parindent:D { -\tex_leftskip:D }
      \skip_set:Nn \tex_rightskip:D { 6\ccwd plus 1fil minus 3\ccwd }
      \skip_sub:Nn \tex_parfillskip:D { \tex_rightskip:D }
      \int_set_eq:NN \tex_interlinepenalty:D \c_ten_thousand
      \tex_indent:D
      \@@_hyper_link:nn {#4} { \box_use:N \l_tmpa_box #2 }
      \tex_penalty:D \c_zero \null \@@_cdot_fill:
      \@@_hyper_link:nn {#4} { { \normalfont #3 } }
      \par
    \group_end:
  }
\cs_new_protected:Npn \@@_toc_dialog:nnn #1#2#3
  {
    \group_begin:
      \kaishu
      \dim_set:Nn \tex_parindent:D { -2\ccwd }
      \skip_set:Nn \tex_leftskip:D { 4\ccwd }
      \skip_set:Nn \tex_rightskip:D { 6\ccwd plus 1fil minus 3\ccwd }
      \skip_sub:Nn \tex_parfillskip:D { \tex_rightskip:D }
      \int_set_eq:NN \tex_interlinepenalty:D \c_ten_thousand
      \tex_indent:D
      \@@_hyper_link:nn {#3} {#1}
      \tex_penalty:D \c_zero \null \@@_cdot_fill:
      \@@_hyper_link:nn {#3} { { \normalfont #2 } }
      \par
    \group_end:
  }
\cs_new_protected_nopar:Npn \@@_toc_figure:nnn #1
  { \@@_toc_figure:nnnn #1 }
\cs_new_protected:Npn \@@_toc_figure:nnnn #1#2#3#4
  {
    \group_begin:
      \tex_par:D
      \tex_noindent:D
      \int_gincr:N \g_@@_toc_int
      \exp_args:No \@@_toc_label:nnn
        { \int_use:N \g_@@_toc_int } {#1} {#4}
      \skip_set:Nn \tex_rightskip:D { 4\ccwd plus 1fil minus 2\ccwd }
      \skip_sub:Nn \tex_parfillskip:D { \tex_rightskip:D }
      \dim_set_eq:NN \tex_hangindent:D \l_tmpa_dim
      \int_set_eq:NN \tex_hangafter:D \c_one
      \int_set_eq:NN \tex_interlinepenalty:D \c_ten_thousand
      \@@_hyper_link:nn {#4} { \box_use:N \l_tmpa_box #2 }
      \@@_cdot_fill:
      \@@_hyper_link:nn {#4} {#3} \tex_par:D
    \group_end:
  }
\cs_new_protected_nopar:Npn \@@_cdot_fill:
  { \tex_leaders:D \box_use:N \l_@@_cdot_box \tex_hfill:D }
\box_new:N \l_@@_cdot_box
\hbox_set_to_wd:Nnn \l_@@_cdot_box { 8pt }
  { \tex_hss:D \textcdot \tex_hss:D }
\NewDocumentCommand \cdotfill { }
  {
    \tex_leaders:D
      \hbox_to_wd:nn { .44em } { \tex_hss:D \textcdot \tex_hss:D }
      \tex_hfill:D
  }
\cs_new_protected:Npn \@@_toc_label:nnn #1#2
  {
    \dim_set:Nn \l_tmpa_dim
      { \zref@extractdefault { toc.#1 } { label@width } { \c_zero_dim } }
    \dim_compare:nNnTF \l_tmpa_dim > \c_zero_dim
      { \hbox_set_to_wd:Nnn \l_tmpa_box { \l_tmpa_dim } }
      { \hbox_set:Nn \l_tmpa_box }
      { \tex_hfill:D #2 . \enspace }
    \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
    \seq_gput_right:No \g_@@_toc_seq { \dim_use:N \l_tmpa_dim }
    \@@_toc_mark:n { \int_use:N \g_@@_toc_int }
    \zref@labelbylist { toc.#1 } { toc@label }
    \prop_gput:Nnn \g_@@_figure_dest_prop {#1}
  }
\int_new:N \g_@@_toc_int
\seq_new:N \g_@@_toc_seq
\prop_new:N \g_@@_figure_dest_prop
\cs_new_protected:Npn \@@_toc_mark:n #1
  { \etex_marks:D \g_@@_toc_label_mark {#1} }

\NewDocumentCommand \fig { s m }
  {
    \xeCJK_leave_vmode:
    \prop_get:NnNTF \g_@@_figure_dest_prop {#2} \l_tmpa_tl
      {
        \@@_save_node:
        \exp_args:No \@@_hyper_link:nn
          { \l_tmpa_tl }
          {
            \@@_restore_node:
            \IfBooleanF #1 { 图 } #2
            \@@_save_node:
          }
        \@@_restore_node:
      }
      { \IfBooleanF #1 { 图 } #2 }
  }

\RenewDocumentCommand \listoffigures { }
  {
    \group_begin:
      \AtBeginShipout { \@@_set_toc_label_width: }
      \@starttoc { lof }
      \AtBeginShipoutNext { \tl_gclear:N \@@_set_toc_label_width: }
    \group_end:
  }
\cs_new_protected_nopar:Npn \@@_set_toc_label_width:
  {
    \str_if_eq_x:nnF
      { \etex_topmarks:D \g_@@_toc_label_mark }
      { \etex_firstmarks:D \g_@@_toc_label_mark }
      { \@@_set_toc_label_width_aux: }
  }
\cs_new_protected_nopar:Npn \@@_set_toc_label_width_aux:
  {
    \tl_gset:Nn \g_@@_toc_label_width_tl { 0pt }
    \int_step_inline:nnnn
      { \etex_firstmarks:D \g_@@_toc_label_mark }
      { 1 }
      { \etex_botmarks:D \g_@@_toc_label_mark }
      {
        \seq_gpop_left:NNTF \g_@@_toc_seq \l_tmpa_tl
          {
            \tl_gset:Nx \g_@@_toc_label_width_tl
              { \dim_max:nn { \g_@@_toc_label_width_tl } { \l_tmpa_tl } }
          }
          { \BOOM }
      }
  }
\newmarks \g_@@_toc_label_mark
\tl_new:N \g_@@_toc_label_width_tl
\zref@newprop * { label@width } [ 0pt ] { \g_@@_toc_label_width_tl }
\zref@newlist { toc@label }
\zref@addprop { toc@label } { label@width }
\newlist { lof } { description } { 3 }
\setlist [ lof ]
  {
    labelsep   = \ccwd ,
    leftmargin = \parindent ,
    topsep  = \bigskipamount ,
    itemsep = \medskipamount ,
    format  = \@@_name_colon:n
  }

\RenewDocumentCommand \tableofcontents { }
  {
    \cleardoublepage
    \group_begin:
      \cs_set_eq:NN \addtocontents \use_none:nn
      \chapter { \contentsname }
      \linespread { 1.5 } \normalsize
      \@starttoc { toc }
    \group_end:
  }

\ctex_appto_cmd:NnnTF \window
  { \ExplSyntaxOff }
  { \if@nobreak \@nobreakfalse \fi }
  { }
  { \ctex_patch_failure:N \window }

\cs_set_protected:Npn \caption@@@addcontentsline #1#2#3#4
  { \addcontentsline {#1} {#2} { {#3} {#4} } }
\ctex_patch_cmd:Nnn \caption@@addcontentsline
  { \ignorespaces }
  { }
\ctex_patch_cmd:Nnn \caption@xdblarg
  { \relax }
  { \empty }

\floatplacement { figure } { htbp }
\tl_set:Nn \topfraction { 0.8 }
\tl_set:Nn \bottomfraction { 0.6 }
\tl_set:Nn \textfraction { 0.1 }
\tl_set:Nn \floatpagefraction { 0.8 }
\skip_set_eq:NN \intextsep \bigskipamount
\skip_set_eq:NN \textfloatsep \intextsep
\skip_set_eq:NN \floatsep \medskipamount
\skip_set:Nn \abovecaptionskip { \intextsep - \smallskipamount }
\skip_zero:N \belowcaptionskip

\skip_set_eq:NN \LTpre \medskipamount
\skip_set_eq:NN \LTpost \LTpre

\counterwithout { figure } { chapter }
\counterwithout { table }  { chapter }

\graphicspath { { figures/ } }
\setkeys { Gin }
  {
    keepaspectratio = true ,
    width = \dim_min:nn { \Gin@nat@width } { \linewidth }
  }

\ctex_patch_cmd:Nnn \captionlabel
  { \caption@setsubtype * { \FR@tmp } }
  { \caption@setsubtype * }
\exp_args:Nc \ctex_appto_cmd:NnnTF { subfloatrow* }
  { \ExplSyntaxOff }
  { \ignorespaces }
  { }
  { \exp_args:Nc \ctex_patch_failure:N { subfloatrow* } }
\floatsetup
  {
    style  = plain ,
    valign = c ,
    heightadjust = none ,
    captionskip  = \abovecaptionskip ,
    floatrowsep     = quad ,
    subfloatrowsep  = quad ,
    capbesidesep    = quad ,
    floatHaslist    = true ,
    capbesideposition = { right , bottom }
  }
\floatsetup [ figure ] { capposition  = bottom }
\floatsetup [ table ]  { capposition  = top }
\floatsetup [ rotfloat ]
  { captionskip = \intextsep }
\newfloatcommand { figurebox } { figure } [ \nocapbeside \capbot ]
\newfloatcommand { tablebox }  { table }  [ \nocapbeside \captop ] [ \FBwidth ]
\DeclareFloatSeparators { mqquad } { \skip_horizontal:n { -2em } }

\DeclareCaptionFont { kaishu } { \kaishu }
\DeclareCaptionLabelFormat { plain } { \bothIfFirst {#1} { \, } #2 }
\DeclareCaptionLabelSeparator { en } { \enspace }
\DeclareCaptionTextFormat { nostrut } { \@@_caption_nostrut:w #1 }
\cs_new:Npn \@@_caption_nostrut:w #1 \caption@ifstrut #2 \par
  { #1 \par }
\captionsetup
  {
    format      = hang ,
    font        = { small , kaishu } ,
    labelfont   = sf ,
    labelformat = plain ,
    labelsep    = en ,
    textformat  = nostrut ,
    hypcap      = true ,
    strut       = off ,
  }
\captionsetup [ figure ] { position = bottom }
\captionsetup [ table ]  { position = top }
\captionsetup [ sub ]
  {
    labelfont   = rm ,
    font        = { footnotesize , kaishu }
  }
\captionsetup [ capbesidefloat ]
  { format = plain }
\captionsetup [ rotfloat ]
  { margin = 4\ccwd }
\captionsetup [ floatrow ]
  { margin = \c_zero_dim }

\tl_gput_right:Nn \caption@prepareslc
  { \cs_set_eq:NN \note \use_none:n }
\tl_gput_right:Nn \FR@loc@
  { \cs_set_eq:NN \note \use_none:n }

\AtBeginDocument { \@@_patch_float_anchor: }
\cs_new_protected_nopar:Npn \@@_patch_float_anchor:
  {
    \ctex_patch_cmd:Nnn \caption@start@
      { \caption@startanchor \@currentHref }
      { \caption@anchor@n { \caption@startanchor \@currentHref } }
  }
\tl_gput_right:Nn \caption@subtypehook
  { \@saveanchorfalse }
\tl_gput_right:Nn \@floatboxreset
  { \@saveanchortrue }
\cs_set_eq:NN \FR@flboxreset \@floatboxreset
\cs_new_protected_nopar:Npn \@saveanchortrue
  { \cs_set_eq:NN \caption@anchor@n \@_save_caption_anchor:n }
\cs_new_protected_nopar:Npn \@saveanchorfalse
  { \cs_set_eq:NN \caption@anchor@n \use:n }
\cs_new_eq:NN \caption@anchor@n \use:n
\cs_new_protected_nopar:Npn \@_save_caption_anchor:n #1
  {
    \box_if_empty:NTF \g_@@_caption_anchor_box
      {
        \hbox_gset:Nn \g_@@_caption_anchor_box
          { \cs_set_eq:NN \caption@raisedlink \use:n #1 }
      }
      {#1}
  }
\box_new:N \g_@@_caption_anchor_box
\cs_new_protected_nopar:Npn \put@caption@anchor
  {
    \box_if_empty:NF \g_@@_caption_anchor_box
      { \@@_put_caption_anchor: }
  }
\cs_new_protected_nopar:Npn \@@_put_caption_anchor:
  {
    \vbox_gset:Nn \@currbox
      {
        \box_use_clear:N \g_@@_caption_anchor_box
        \nointerlineskip
        \box_use_clear:N \@currbox
      }
  }
\ctex_preto_cmd:NnnTF \@largefloatcheck
  { \ExplSyntaxOff }
  { \put@caption@anchor }
  { }
  { \ctex_patch_failure:N \@largefloatcheck }

\ctex_patch_cmd:Nnn \float@endH
  { \vskip \intextsep }
  { \addvspace \intextsep \nointerlineskip }
\ctex_patch_cmd:Nnn \float@endH
  { \vskip \intextsep }
  {
    \vskip \intextsep
    \nointerlineskip
    \if@nobreak \@nobreakfalse \fi
  }
\ctex_patch_cmd:Nnn \float@endH
  { \box \@currbox }
  { \put@caption@anchor \box \@currbox }

%% <--- http://tex.stackexchange.com/a/40896
\ctex_patch_cmd:Nnn \@addtocurcol
    {\vskip \intextsep}%
    {\edef\save@first@penalty{\the\lastpenalty}\unpenalty
     \ifnum \lastpenalty = \@M  % hopefully the OR penalty
        \unpenalty
     \else
        \penalty \save@first@penalty \relax % put it back
     \fi
      \ifnum\outputpenalty <-\@Mii
                         \addvspace\intextsep
                         \vskip\parskip
      \else
                         \addvspace\intextsep
      \fi}
\ctex_patch_cmd:Nnn \@addtocurcol
    {\vskip\intextsep \ifnum\outputpenalty <-\@Mii \vskip -\parskip\fi}%
    {\ifnum\outputpenalty <-\@Mii
       \aftergroup\vskip\aftergroup\intextsep
       \aftergroup\nointerlineskip
     \else
       \vskip\intextsep
     \fi}
\ctex_patch_cmd:Nnn \@getpen { \@M } { \@Mi }
%% --->

\ctex_patch_cmd:Nnn \LT@start
  { \vskip \LTpre }
  { \nointerlineskip \vskip \LTpre }
\ctex_appto_cmd:NnnTF \endlongtable
  { \ExplSyntaxOff }
  {
    \nointerlineskip
    \addtocounter { table } { \m@ne }
  }
  { }
  { \ctex_patch_failure:N \endlongtable }

\skip_set:Nn \LTleft { \parindent }
\skip_set_eq:NN \LTright \fill

\cs_new_protected_nopar:Npn \@@_endnote_chapter:
  {
    \@@_endnote_end:
    \group_begin:
      \cs_set_eq:NN \protect \@unexpandable@protect
      \tl_gset:Nx \g_@@_current_chapter_tl
        {
          \CTEXifname { \CTEXthechapter ： } { }
          \@currentlabelname
        }
    \group_end:
  }
\tl_new:N \g_@@_current_chapter_tl

\NewDocumentCommand \theendnotes { }
  { \msg_term:n { NO ~ ENDNOTE! } }

\NewDocumentEnvironment { endnotes } { +m }
  {
    \section {#1}
    \footnotesize
    \entlist
  }
  { \endentlist }

\cs_new_nopar:Npn \note
  {
    \cs_if_eq:NNTF \protect \@typeset@protect
      { \@@_endnote:n }
      { \use_none:n }
  }
\pdfstringdefDisableCommands
  { \cs_set_eq:NN \note \use_none:n }
\ctex_at_end_package:nn { gettitlestring }
  {
    \GetTitleStringDisableCommands
      { \cs_set_eq:NN \note \use_none:n }
    \tl_put_right:Nn \GTS@PredefinedLeftCmds
      { \GTS@TestLeft \note \GTS@CdrTwo }
  }
\cs_new_protected:Npn \@@_endnote:n #1
  {
    \tex_unskip:D
    \@@_save_node:
    \@@_endnote_open:
    \@@_endnote_mark:
    \@@_endnote_text:n {#1}
    \@@_restore_node:
  }
\cs_new_protected_nopar:Npn \@@_save_node:
  {
    \scan_stop:
    \dim_compare:nNnTF \tex_lastkern:D = \c_zero_dim
      { \xeCJK_cs_gclear:N \@@_restore_node: }
      { \@@_save_node_aux: }
  }
\cs_new_eq:NN \@@_restore_node: \prg_do_nothing:
\cs_new_protected_nopar:Npn \@@_save_node_aux:
  {
    \dim_set_eq:NN \l_tmpa_dim \tex_lastkern:D
    \tex_unkern:D
    \dim_compare:nNnTF \tex_lastkern:D = { - \l_tmpa_dim }
      {
        \cs_gset_protected_nopar:Npx \@@_restore_node:
          {
            \tex_kern:D \dim_use:N \tex_lastkern:D \exp_stop_f:
            \tex_kern:D \dim_use:N \l_tmpa_dim     \exp_stop_f:
          }
        \tex_unkern:D
      }
      { \tex_kern:D \l_tmpa_dim }
  }
\cs_new_protected_nopar:Npn \@@_endnote_mark:
  {
    \hbox_set:Nn \l_tmpa_box
      {
        \Hy@localanchornametrue
        \fontsize { .7\ccwd } { .7\ccwd } \selectfont
        \refstepcounter { endnote }
        \@@_hyper_link:nn
          { entlist . \HyperGlobalCurrentHref }
          { \theendnote }
      }
    \hbox_set:Nn \l_tmpa_box
      {
        \box_move_up:nn
          { \ccwd - \box_ht:N \l_tmpa_box }
          { \box_use_clear:N \l_tmpa_box }
      }
    \box_set_ht:Nn \l_tmpa_box { \c_zero_dim }
    \box_use_clear:N \l_tmpa_box
  }
\cs_new_protected:Npn \@@_endnote_text:n #1
  {
    \group_begin:
      \set@display@protect
      \iow_now:Nx \g_@@_endnote_iow
        {
          \c_backslash_str enitem
            { \HyperGlobalCurrentHref }
            { \arabic { endnote } }
            #1
        }
    \group_end:
  }
\cs_new_protected_nopar:Npn \@@_endnote_open:
  {
    \cs_gset_eq:NN \theendnotes \@@_input_endnote:
    \bool_gset_true:N \g_@@_endnote_open_bool
    \iow_open:Nn \g_@@_endnote_iow { \c_sys_jobname_str .ent }
    \cs_gset_eq:NN \@@_endnote_open: \@@_endnote_begin:
    \@@_endnote_begin:
  }
\cs_new_protected_nopar:Npn \@@_input_endnote:
  {
    \@@_endnote_end:
    \iow_close:N \g_@@_endnote_iow
    \chapter { 注释 }
    \group_begin:
    \ctexset
      {
        section = {
          format     = \centering \sffamily \bfseries ,
          beforeskip = \bigskipamount ,
          afterskip  = \bigskipamount
        }
      }
    \file_input:n { \c_sys_jobname_str .ent }
    \group_end:
  }
\cs_new_protected_nopar:Npn \@@_endnote_begin:
  { \bool_if:NF \g_@@_endnote_bool { \@@_endnote_heading: } }
\cs_new_protected_nopar:Npn \@@_endnote_heading:
  {
    \stepcounter { entlist }
    \bool_gset_true:N \g_@@_endnote_bool
    \iow_now:Nx \g_@@_endnote_iow
      {
        \iow_newline:
        \c_backslash_str begin { endnotes }
          { \exp_not:o { \g_@@_current_chapter_tl } }
      }
  }
\cs_new_protected_nopar:Npn \@@_endnote_end:
  {
    \bool_if:NTF \g_@@_endnote_bool
      {
        \iow_now:Nx \g_@@_endnote_iow
          { \c_backslash_str end { endnotes } }
        \bool_gset_false:N \g_@@_endnote_bool
      }
      { }
  }
\iow_new:N \g_@@_endnote_iow
\bool_new:N \g_@@_endnote_bool
\newcounter { entlist }
\newcounter { endnote } [ entlist ]
\tl_gset:Nn \theendnote { \circedctr { endnote } }
\tl_gset:Nn \theHendnote
  { \arabic { entlist } . \arabic { endnote } }

\newlist { entlist } { description } { 1 }
\setlist [ entlist ]
  {
    wide , labelsep = 0.5em ,
    before = \cs_set_eq:NN \enitem \@@_enitem:nn
  }
\cs_new_protected_nopar:Npn \@@_enitem:nn #1#2
  { \@item [ \@@_enitem_format:nn {#1} {#2} ] }
\cs_new_protected_nopar:Npn \@@_enitem_format:nn #1#2
  {
    \@@_hyper_anchor:n { entlist . #1 }
    \@@_hyper_link:nn {#1} { \circednum {#2} }
  }
\cs_new_eq:NN \enitem \use_none:nn

\NewDocumentEnvironment { thm } { o m }
  {
    \IfNoValueTF {#1}
      {
        \group_begin:
          \hbox_set:Nn \l_tmpa_box {#2}
        \exp_args:NNf \group_end:
        \@@_thm:nn { \dim_eval:n { \box_wd:N \l_tmpa_box } }
      }
      { \@@_thm:nn { \dim_eval:n {#1} } }
      {#2}
  }
  { \enddescription }

\cs_new_protected_nopar:Npn \@@_thm:nn #1#2
  {
    \description
      [
        labelsep      =  \ccwd ,
        labelwidth    = #1 ,
        leftmargin    = \dim_eval:n { #1 + \labelsep } ,
        listparindent = \c_zero_dim ,
        align  = fillleft ,
        topsep = \smallskipamount ,
        format = \sffamily \bfseries
      ]
    \item [ {#2} ]
  }

\NewDocumentEnvironment { rulelist } { O { } }
  {
    \description
      [
        labelsep      = \ccwd ,
        labelwidth    = \ccwd ,
        leftmargin    = \parindent ,
        listparindent = \c_zero_dim ,
        align  = fillleft ,
        topsep = \smallskipamount ,
        format = \bfseries \@@_name_colon:n ,
        #1
      ]
  }
  { \enddescription }

\SetEnumitemKey { step }
  {
    labelsep = \ccwd ,
    label    = 步骤 \arabic* \rlap {：} ,
  }
\NewDocumentCommand \system { m }
  {
    \mode_if_math:TF
      { \mathbin { \text { \textsf {#1} } } }
      { \textsf {#1} }
  }
\group_begin:
\char_set_catcode_active:N \"
\cs_new_protected_nopar:Npn " #1 "
  { \system {#1} }
\pdfstringdefDisableCommands
  { \tl_clear:N " }
\AtBeginDocument { \char_set_catcode_active:N \" }
\group_end:

\DeclareExpandableDocumentCommand \@@_pdfstring_cr:w { s o m }
  { #3 }
\pdfstringdefDisableCommands
  { \cs_set_eq:NN \\ \@@_pdfstring_cr:w }

\NewDocumentCommand \aitem { u \> }
  { \item \alignbox { \l_@@_alignbox_width_tl } { #1 } }
\NewDocumentCommand \alignbox { m m }
  {
    \xeCJK_leave_vmode:
    \hbox_to_wd:nn {#1} { #2 \tex_unskip:D \tex_hfill:D }
    \tex_ignorespaces:D
  }
\NewDocumentCommand \setaitem { m }
  { \tl_set:Nn \l_@@_alignbox_width_tl {#1} }
\tl_new:N \l_@@_alignbox_width_tl
\setaitem { .5\linewidth }

\NewDocumentCommand \tabindent { m }
  { \skip_horizontal:n { (\linewidth - 2em) / 2 - #1 } }

\NewDocumentCommand \indentcr { s O { \parindent }  }
  {
    \IfBooleanTF #1
      {
        \dim_set:Nn \l_@@_hang_indent_dim
          { - \l_@@_hang_indent_dim }
      }
      { \dim_set:Nn \l_@@_hang_indent_dim {#2} }
    \dim_set_eq:NN \l_@@_hang_parindent_dim \parindent
    \cs_set_eq:NN \\ \@@_hang_cr:w
  }
\cs_new_eq:NN \@@_hang_cr:w \@centercr
\ctex_patch_cmd:Nnn \@@_hang_cr:w
  { \par }
  { \HangPar }
\cs_new_protected_nopar:Npn \HangPar
  {
    \par
    \ctexset { autoindent = false }
    \dim_add:Nn \l_@@_hang_parindent_dim
      { \l_@@_hang_indent_dim }
    \dim_set_eq:NN \parindent \l_@@_hang_parindent_dim
  }
\dim_new:N \l_@@_hang_indent_dim
\dim_new:N \l_@@_hang_parindent_dim

\allowdisplaybreaks
\dim_zero:N \jot
\DeclareMathOperator \fibo { FIBO }
\DeclareMathOperator \mG   { G }
\DeclareMathOperator \mH   { H }
\DeclareMathOperator \mF   { F }
\DeclareMathOperator \mM   { M }
\DeclareMathOperator \mQ   { Q }
\DeclareMathOperator \INT  { INT }
\NewDocumentCommand \me { }
  { \mathrm { e } }
\NewDocumentCommand \mi { }
  { \mathrm { i } }
\NewDocumentCommand \TNT { }
  { \mathrm { TNT } }
\NewDocumentCommand \moG { }
  { \mathrm { G } }
\NewDocumentCommand \diff { }
  { \mathop { } \! \mathrm { d } }

\NewEnviron { dnaseq } [1] [ \linewidth ]
  { \tex_noindent:D \exp_args:Nno \@@_dna_seq:nn {#1} { \BODY } }

\newfontfamily \XITSmath { XITS ~ Math }
\ProvideTextCommandDefault \textlcurvearrowdown
  { \hmode@start@before@group { \XITSmath ^^^^2938 } }
\ProvideTextCommandDefault \textrcurvearrowdown
  { \hmode@start@before@group { \XITSmath ^^^^2939 } }

\cs_new_protected_nopar:Npn \@@_dna_seq:nn #1#2
  {
    \vbox:n
      {
        \tiny \ttfamily
        \offinterlineskip
        \skip_set:Nn \lineskip { 1pt }
        \hbox_set:Nn \l_tmpa_box { T }
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
        \int_set:Nn \l_@@_line_int
          { \dim_ratio:nn {#1} { \l_tmpa_dim } - 1 }
        \dim_set:Nn \linewidth { \l_@@_line_int \l_tmpa_dim }
        \dim_set:Nn \l_tmpa_dim
          { ( \box_ht:N \l_tmpa_box + \lineskip ) / 2 }
        \hbox_set:Nn \l_@@_lmark_box
          {
            \smash
              {
                \box_move_down:nn { \l_tmpa_dim }
                  { \hbox_overlap_left:n { \textrcurvearrowdown \, } }
              }
          }
        \hbox_set:Nn \l_@@_rmark_box
          {
            \smash
              {
                \box_move_down:nn { \l_tmpa_dim }
                  { \hbox_overlap_right:n { \, \textlcurvearrowdown } }
              }
          }
        \@@_dna_seq:n {#2}
      }
  }
\int_new:N \l_@@_line_int
\box_new:N \l_@@_lmark_box
\box_new:N \l_@@_rmark_box
\cs_new_protected_nopar:Npn \@@_dna_seq:n #1
  {
    \int_zero:N \l_tmpa_int
    \@@_normal:w #1 \q_recursion_tail \q_recursion_stop
  }
\cs_new_protected_nopar:Npn \@@_normal:w
  {
    \tex_hbox:D \c_group_begin_token
    \@@_normal_line:w
  }
\cs_new_protected_nopar:Npn \@@_normal_line:w #1
  {
    \quark_if_recursion_tail_stop_do:Nn #1
      { \c_group_end_token }
    #1
    \int_incr:N \l_tmpa_int
    \int_compare:nNnTF \l_tmpa_int < \l_@@_line_int
      { \@@_normal_line:w }
      { \@@_normal_line_stop:w }
  }
\cs_new_protected_nopar:Npn \@@_normal_line_stop:w #1
  {
    \quark_if_recursion_tail_stop_do:Nn #1
      { \c_group_end_token }
    \box_use:N \l_@@_rmark_box
    \c_group_end_token
    \@@_reverse:w #1
  }
\cs_new_protected_nopar:Npn \@@_reverse:w
  {
    \tex_hbox:D \c_group_begin_token
    \@@_reverse_line:w \q_mark
  }
\cs_new_protected_nopar:Npn \@@_reverse_line:w #1 \q_mark #2
  {
    \quark_if_recursion_tail_stop_do:Nn #2
      { \@@_reverse_stop:n {#1} }
    \int_incr:N \l_tmpa_int
    \int_compare:nNnTF \l_tmpa_int < \l_@@_line_int
      { \@@_reverse_line:w }
      { \@@_reverse_line_stop:w }
    #2#1 \q_mark
  }
\cs_new_protected_nopar:Npn \@@_reverse_line_stop:w #1 \q_mark #2
  {
    \quark_if_recursion_tail_stop_do:Nn #2
      { \@@_reverse_stop:n {#1} }
    \box_use:N \l_@@_lmark_box
    #1
    \c_group_end_token
    \@@_normal:w #2
  }
\cs_new_protected_nopar:Npn \@@_reverse_stop:n #1
  {
    \hbox_to_wd:nn { \linewidth } { \tex_hfil:D #1 }
    \c_group_end_token
  }

\cs_new_protected_nopar:Npn \tikzxtest
  {
    \dim_compare:nNnTF { \dim_abs:n { \x1 - \x2 } } < { 1pt }
      { \cs_set_eq:NN \tikzxtestresult \use_i:nn }
      { \cs_set_eq:NN \tikzxtestresult \use_ii:nn }
  }

\cs_set_eq:NN \nt@stopline \@stopline
\ctex_patch_cmd_all:NnnnTF \nt@stopline { \ExplSyntaxOff }
  { \@itemfudge }
  { \@itemfudge \nt@numbox }
  { }
  { \ctex_patch_failure:N \nt@stopline }
\cs_new_protected_nopar:Npn \@@_tabbing_number_box:
  {
    \int_gincr:N \g_@@_tabbing_line_int
    \hbox_overlap_right:n
      {
        \hbox_to_wd:nn { 3.5\ccwd }
          { \tex_hfil:D ( \int_use:N \g_@@_tabbing_line_int ) }
      }
  }
\cs_new_eq:NN \nt@numbox \@@_tabbing_number_box:
\cs_new_protected_nopar:Npn \@@_tabbing_no_number:
  {
    \cs_gset_protected_nopar:Npn \nt@numbox
      { \cs_gset_eq:NN \nt@numbox \@@_tabbing_number_box: }
  }
\int_new:N \g_@@_tabbing_line_int
\NewDocumentEnvironment { tabbing* } { o }
  {
    \IfNoValueTF {#1}
      { \int_gzero:N \g_@@_tabbing_line_int }
      {
        \tl_if_blank:nF {#1}
          { \int_gset:Nn \g_@@_tabbing_line_int {#1} }
      }
    \cs_set_eq:NN \@stopline \nt@stopline
    \cs_set_eq:NN \nonumber \@@_tabbing_no_number:
    \tabbing
  }
  { \endtabbing }

\NewDocumentCommand \hangparshape { m }
  {
    \tex_noindent:D
    \int_set:Nn \l_tmpa_int {#1}
    \tex_parshape:D \l_tmpa_int
      \int_step_function:nnnN
        { 0 } { 1 } { \l_tmpa_int - 1 } \@@_hang_parshape:n
    \scan_stop:
  }

\cs_new_nopar:Npn \@@_hang_parshape:n #1
  { ~ \dim_eval:n { #1\ccwd } ~ \dim_eval:n { \linewidth - #1\ccwd } }

\NewDocumentCommand \hangparshapedb { m }
  {
    \tex_noindent:D
    \int_set:Nn \l_tmpa_int {#1}
    \tex_parshape:D \int_eval:n { \l_tmpa_int * 2 + 1 }
      \int_step_function:nnnN
        { 0 } { 1 } { \l_tmpa_int - 1 } \@@_hang_parshape:n
      \l_tmpa_int \ccwd \dim_eval:n { \linewidth - \l_tmpa_int \ccwd }
      \int_step_function:nnnN
        { \l_tmpa_int - 1 } { -1 } { 0 } \@@_hang_parshape:n
    \scan_stop:
  }

\NewDocumentCommand \textcombine { m }
  {
    \prop_get:NnNTF \g_@@_combine_prop {#1} \l_tmpa_tl
      {
        \mode_if_vertical:TF
          { \tex_indent:D } { \@@_ccglue: }
        \tl_use:N \l_tmpa_tl
        \@@_make_node:
      }
      { 〔 \hbox:n {#1} 〕 }
  }
\pdfstringdefDisableCommands
  { \cs_set_eq:NN \textcombine \@@_combine_raw:n }
\cs_new_nopar:Npn \@@_combine_raw:n #1
  {〔 #1 〕}

\cs_new_protected_nopar:Npn \@@_ccglue:
  {
    \xeCJK_if_last_node:nT { CJK }
      {  \xeCJK_remove_node: \CJKglue }
  }
\cs_new_protected_nopar:Npn \@@_make_node:
  { \xeCJK_make_node:n { CJK } }

\prop_new:N \g_@@_combine_prop
\prop_gput:Nnn \g_@@_combine_prop { 卧 龙 }
  { \@@_combine_stack:nnnn { 卧 } { 龙 } { .5 } { .5 } }
\prop_gput:Nnn \g_@@_combine_prop { 宓 豕 }
  { \@@_combine_stack:nnnn { 宓 } { 豕 } { .5 } { .5 } }
\prop_gput:Nnn \g_@@_combine_prop { 白  灬 }
  { \@@_combine_stack:nnnn { 白 } { 灬 } { .7 } { 1 } }
\prop_gput:Nnn \g_@@_combine_prop { 若 鸟 }
  { \@@_combine_scale:nnnn { 若 } { 鸟 } { .5 } { .6 } }
\prop_gput:Nnn \g_@@_combine_prop { 勾 鸟 }
  { \@@_combine_scale:nnnn { 勾 } { 鸟 } { .5 } { .6 } }
\prop_gput:Nnn \g_@@_combine_prop { 足 共 }
  { \@@_combine_trim:nnnn { 距 } { 共 } { .55 } { .6 } }
\prop_gput:Nnn \g_@@_combine_prop { 彳 瓦 }
  { \@@_combine_trim:nnnn { 行 } { 瓦 } { .6 } { .75 } }
\prop_gput:Nnn \g_@@_combine_prop { 犭 若 }
  { \@@_combine_trim:nnnn { 犯 } { 若 } { .6 } { .75 } }
\prop_gput:Nnn \g_@@_combine_prop { 犭 析 }
  { \@@_combine_trim:nnnn { 犯 } { 析 } { .6 } { .7 } }
\prop_gput:Nnn \g_@@_combine_prop { 犭 易 }
  { \@@_combine_trim:nnnn { 犯 } { 易 } { .6 } { .7 } }
\prop_gput:Nnn \g_@@_combine_prop { 犭 累 }
  { \@@_combine_trim:nnnn { 犯 } { 累 } { .6 } { .7 } }
\prop_gput:Nnn \g_@@_combine_prop { 犭 丝 }
  { \@@_combine_trim:nnnn { 犯 } { 丝 } { .6 } { .7 } }
\cs_new_protected_nopar:Npn \@@_combine_stack:nnnn #1#2#3#4
  {
    \hbox_set:Nn \l_tmpa_box {#1}
    \vbox_to_ht:nn { \box_ht:N \l_tmpa_box }
      {
        \box_scale:Nnn \l_tmpa_box { 1 } {#3}
        \box_use:N \l_tmpa_box
        \tex_vss:D
        \hbox_set:Nn \l_tmpa_box {#2}
        \box_scale:Nnn \l_tmpa_box { 1 } {#4}
        \box_use:N \l_tmpa_box
      }
  }
\cs_new_protected_nopar:Npn \@@_combine_scale:nnnn #1#2#3#4
  {
    \hbox_set:Nn \l_tmpa_box {#1}
    \hbox_to_wd:nn { \box_wd:N \l_tmpa_box }
      {
        \box_scale:Nnn \l_tmpa_box {#3} { 1 }
        \box_use:N \l_tmpa_box
        \tex_hss:D
        \hbox_set:Nn \l_tmpa_box {#2}
        \box_scale:Nnn \l_tmpa_box {#4} { 1 }
        \box_use:N \l_tmpa_box
      }
  }
\cs_new_protected_nopar:Npn \@@_combine_trim:nnnn #1#2#3#4
  {
    \hbox_set:Nn \l_tmpa_box {#1}
    \hbox_to_wd:nn { \box_wd:N \l_tmpa_box }
      {
        \box_trim:Nnnnn \l_tmpa_box
          { 0pt } { 0pt } { #3 \box_wd:N \l_tmpa_box } { 0pt }
        \box_clip:N \l_tmpa_box
        \box_use:N \l_tmpa_box
        \tex_hss:D
        \hbox_set:Nn \l_tmpa_box {#2}
        \box_scale:Nnn \l_tmpa_box {#4} { 1 }
        \box_use:N \l_tmpa_box
      }
  }

\NewDocumentCommand \pnum { m }
  { ( #1 ) }

\NewDocumentCommand \blankline { }
  {
    \tex_vrule:D height \c_zero_dim
                 width 3\ccwd
                 depth .6pt \scan_stop:
  }

\NewDocumentCommand \basecell { m m }
  {
    \hcoffin_set:Nn \l_tmpa_coffin
      { \hbox_to_wd:nn { 2em } { \tex_hss:D #1  \tex_hss:D  } }
    \hcoffin_set:Nn \l_tmpb_coffin { $ #2 $ }
    \coffin_attach:NnnNnnnn
      \l_tmpa_coffin { r } { H }
      \l_tmpb_coffin { l } { H } { 1em } { -2ex }
    \coffin_typeset:Nnnnn \l_tmpa_coffin
      { l } { H } { \c_zero_dim } { \c_zero_dim }
  }
