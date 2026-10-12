\environment mycv-env
%\showframe
\starttext
\title{简历}
\midaligned{李延瑞（lyr.m2@live.cn）}
\midaligned{2026 年 10 月 11 日}
\blank
\startcolumns[n=2]
\placecontent
\stopcolumns

\subject{前言}

当我开始筹谋为自己写一份简历并希望能得到一份真正的工作的时候，我在收拾已经混乱很久的房间。不熟悉我的人，或者熟悉但不理解我的人，大概会觉得，此人过于懒惰。实际上，房间之所以混乱，是因为它是一个战场，硝烟未散。

当然，即使理解我的人，未必同意，使用 \METAPOST\ 语言，以文学编程方式为 \CONTEXT\ 编写一个用于画流程图的模块算是一场战争。不过，我的确为此投入战斗一个月有余，而类似的战争在我的生平里，早已数不过来。在这些战争里，我赢了，我也输了。我赢得了战争本身的胜利，却输掉了战争本应具备的价值。

有人认为，唯有我好好写一份简历，投给某个将军，参与他们的战争，兴许能获得我本该具备的价值。若对方真的是个将军，我会欣然而往，可是若对方是个奴隶主呢？我的简历，兴许是一纸卖身契，而且还要看人家是否愿意买。不过，我总得尝试一下。这意味着，我又要进入一场战争了，用 \CONTEXT\ 写一份简历，依然是以文学编程的方式，而我的房间也将再次混乱。

这是我第二次写简历。上一次写简历，还是公元 2004 年本科毕业前的春天。前几天，刘欢死了。大家在讨论他当年唱的那首「从头再来」。我并不知道我有没有从头再来的能力和机会。李白说，天生我材必有用，可他中年失业后，一直穷困潦倒。我拿他当预防针吧。君子见机，达人知命。

\section{页面布局}

正常的文档，版心四周需要留出足够的空白，用于添加批注。简历不需要如此，其版心需要足够大，尽量用寥寥几页纸装满我的生平。以下代码基于订口（\type{backspace}）尺寸定义了页面整体布局：

@ 简历样式 # [typing]
\setuplayout[backspace=.075\paperwidth,
             width=\dimexpr\paperwidth-2\backspace\relax,
             topspace=\backspace,header=0cm,footer=0cm,
             height=\dimexpr\paperheight -2\topspace\relax]
@

\noindent 上述代码将订口尺寸设为 0.075 倍的纸张宽度，版心宽度是纸张宽度减去 2 倍订口尺寸，这也意味着翻口尺寸与订口尺寸相等。天头（header）和地脚（footer）的尺寸也等于订口。注意，width 是版心宽度，但 \type{height} 却并非版心高度，而是版心高度加上页眉（header）与页脚（footer）的高度，故而后两者尺寸设为 0。此外，还需要注意，\type{\dimexpr ...\relax} 是 LuaMeta\TEX\ 引擎支持的原语，可直接基于 \TEX\ 宏或寄存器完成加减乘除等运算。

文档需要设为单面模式，并消除默认页码：

@ 简历样式 # +
\setuppagenumbering[alternative=singlesided,location=]
@

\noindent 之所以消除默认页码，是因为后续要制作更具个性化的页码。

\section{背景}

我想在简历的页眉和页脚区域各画两条线，一方面用于装饰，另一方面用于标记版心区域同时也能用于呈现某些信息，例如页码。虽然在上一节所作的页面布局设定中，页眉和页脚区域皆设为 0，但是我们可以用 MetaPost 画出与纸张同样尺寸的图形，并将其作为页面背景，这意味着在背景的任何一处，皆能画出我们所需要的内容，亦即没有页眉和页脚区域，我们也能在背景里构造出它们来。

首先，需要先用 \METAPOST\ 的背景色画出两个点，用于固定背景尺寸，使之与纸张尺寸相同，从而构造出背景空间，其坐标原点是背景或页面的左下角点。

@ 构造背景空间 #
draw (0, 0) withcolor background;
draw (PaperWidth, PaperHeight) withcolor background;
@

在页面空间里，寻找版心的顶边位置，在该位置画一条直线：

@ 画出版心顶线 #
numeric linethickness; color linecolor;
linethickness := \getvariable{cv}{linethickness};
linecolor := \getvariable{cv}{linecolor};
pair a, b;
a := (BackSpace, PaperHeight - .5TopSpace);
b := (BackSpace + TextWidth, ypart a);
draw a -- b withpen pencircle scaled linethickness withcolor linecolor;
@

\noindent 线条的粗度和颜色，是 \CONTEXT\ 层面里自定义的变量：

@ 简历参数 #
\setvariables[cv][linethickness=2pt,linecolor=darkblue]
@

\noindent 我们在 \CONTEXT\ 排版环境里使用 \METAPOST\ 画图，实际上这两个环境是通过 \METAFUN\ 连接的，故而可以在 \METAPOST\ 代码里直接使用 \TEX/\CONTEXT\ 宏。\CONTEXT\ 编译器在遇到混有 \TEX/\CONTEXT\ 宏的 \METAPOST\ 代码时，会先展开这些宏，然后再编译 \METAPOST\ 代码。

按照版心顶线的画法，画出版心底线：

@ 画出版心底线 #
pair c;
a := (BackSpace, .5TopSpace); b := (BackSpace + TextWidth, ypart a);
c := .5[a, b];
drawoptions(withpen pencircle scaled linethickness withcolor linecolor);
if \number\lastuserpage = 1:
  draw a -- b;
else:
  numeric delta; delta := 1.75BodyFontSize;
  picture pn; pn := textext("{\bf\userpagenumber}");
  draw (a -- (c shifted (-delta, 0)))
          .. (c shifted (0, .5delta)) .. ((c shifted (delta, 0)) -- b);
  draw pn shifted c;
fi;
@

\noindent 版心底线有两种。若简历只有 1 页，底线只是一条直线。若简历是多页，底线是一条中部有所跳跃的直线，跳跃区域含有页码。

\noindent 将上述 \METAPOST\ 代码置于 \type{useMPgraphic} 环境，然后通过 overlay 机制使之成为页面背景：

@ 简历页面背景 #
\startuseMPgraphic{cvbackground}
# 构造背景空间 @
# 画出版心顶线 @
# 画出版心底线 @
# 背景里的其他元素 @
\stopuseMPgraphic
\defineoverlay[cvbackground][\useMPgraphic{cvbackground}]
\setupbackgrounds[page][background=cvbackground]
@

以下是为了测试简历背景效果而构造的环境，虽然简历的纸张尺寸通常是 A4，但是为了在此展示上述代码构造的页面背景效果，我使用了 A8。

@ 简历页面背景测试环境 #
\usemodule[zhfonts]
\setuppapersize[A8][A8]
# 简历参数 @
# 简历样式 @
# 简历页面背景 @
@

首先，验证单页情况，结果见图 \in[bg-test] 左 1。为了表现出版心顶线和底线分别位于页眉和页脚的中部，在该示例中，开启了页面布局网格。

@ 单页简历背景测试 #
# 简历页面背景测试环境 @
\showframe % 显示页面布局
\starttext
\midaligned{单页}
\stoptext
@

以下示例测试了多页情况，结果见图 \in[bg-test] 右 2 和 右 3。

@ 简历页面背景测试 2 #
# 简历页面背景测试环境 @
\starttext
\midaligned{第一页}
\page
\midaligned{第二页}
\stoptext
@

\placefigure[here][bg-test]{多页背景测试}{
  \startfloatcombination[nx=3,ny=1]
  \placefigure[nonumber]{单页}{\externalfigure[test/01.pdf][frame=on]}
  \placefigure[nonumber]{多页 1}{\externalfigure[test/02.pdf][page=1,frame=on]}
  \placefigure[nonumber]{多页 2}{\externalfigure[test/02.pdf][page=2,frame=on]}
  \stopfloatcombination
}

\section{标题}

简历通常只需要两层标题。主标题通常是个人姓名，次级标题则是诸如求职意向、教育背景、工作经历、个人技能等内容的标题。这两层标题不需要序号。我选择直接基于 \CONTEXT\ 的 \tex{title} 和 \tex{subject} 构造主次标题，并将其样式设定为

@ 简历样式 # +
\setupheads[indentnext=yes]
\setuphead[title,subject][before={\blank[halfline]},after={\blank[halfline]}]
\setuphead[title][style=\getvariable{cvtitle}{style}]
\setuphead[subject][style=\getvariable{cvsubject}{style}]
@

\noindent 标题之后的段落首行需要缩进，且标题前后留出一小段空白。主标题字号比正文大 3 级，次级标题字号比正文大 1 级：

@ 简历参数 # +
\setvariables[cvtitle][style=\bfc]
\setvariables[cvsubject][style=\bfa]
@

主标题的样式只作上述设定之外。次级标题，我想增加两条底线作为装饰，同时也能让简历的各个区域的分野更为清晰。第一条底线需要与标题等长且为粗线，第二条底线横贯版心。这两条底线，使用 \METAPOST\ 很容易画出，前提是定义一个专用的盒子，用于排版标题内容，且基于 \CONTEXT\ 的 overlay 机制为其构造背景，而两条底线便是背景图形。首先，定义盒子并设定其样式：

@ 小节标题盒子 #
\defineframed
  [cvframed]
  [width=\textwidth,frame=ff,align={flushleft,lohi},background=BottomLines]
@

\noindent \type{BottomLines} 是 overlay 的名字，该 overlay 是同样名为 \type{BottomLines} 的 \METAPOST\ 图形：

@ 小节标题盒子 # +
\defineoverlay[BottomLines][\useMPgraphic{BottomLines}]
@

以下代码基于底线粗度、标题宽度和颜色以及 overlay 的尺寸，画出小节标题底线：

@ 画出小节标题底线 #
numeric thi, w; color linecolor;
thi := \getvariable{cvsubject}{bottomlinethickness};
w := \getvariable{cvsubject}{width};
linecolor := \getvariable{cvsubject}{bottomlinecolor};
% 画底线
path bottomline;
bottomline := (.5thi, 0) -- (w, 0);
draw bottomline withpen pencircle scaled thi withcolor transparent(1, .5, linecolor);
% 画版心贯穿线
path splitline;
splitline := (0, 0) -- (OverlayWidth, 0);
draw splitline withpen pencircle scaled 1pt withcolor linecolor;
@

\noindent 注意，\type{bottomline} 的起点，其 $x$ 坐标向右有所偏移，这是在做线宽补偿。若 overlay 为 \METAPOST\ 图形，\CONTEXT\ 会将图形中心与 overlay 区域的中心对准，然后以 overlay 边框裁剪图形，而 \METAPOST\ 图形中的线条加粗后，加粗部分会导致图形尺寸有所溢出，从而被 overlay 边框裁掉，所以在画线时，要注意对线宽予以补偿。同理，以隐形辅助点限定图形空间时，也要考虑线宽补偿，亦即

@ 画出小节标题底线 # +
draw (0, OverlayHeight - .5thi) withcolor background;
@

于是，便可得到小节标题盒子的背景图形：

@ 小节标题盒子 # +
\startuseMPgraphic{BottomLines}
# 画出小节标题底线 @
\stopuseMPgraphic
@

底线的粗度和颜色，可以作为简历参数的一部分，其默认值如下：

@ 简历参数 # +
\setvariables[cvsubject][bottomlinethickness=4pt,bottomlinecolor=darkblue]
@

\noindent 但是小节标题内容的宽度值需要基于小节标题样式中设定的字号，并基于 \TEX\ 盒子的宽度方可得到，将该过程定义为 \CONTEXT\ 宏：

@ 设置小节标题宽度 #
\define[1]\setsubjectwidth{%
  \setbox0\hbox{\getvariable{cvsubject}{style} #1}%
  \setvariables[cvsubject][width=\the\wd0]%
}
@

\noindent 为了能让上述宏得以工作，需要为 \tex{subject} 定义专用的排版命令：

@ 简历样式 # +
# 设置小节标题宽度 @
\setuphead[subject][command=\subjectCMD]
\define[2]\subjectCMD{%
  \setsubjectwidth{#2}\cvframed{#2}%
}
@

\noindent 上述设定可以让 \tex{subject} 在工作时，以 \tex{subjectCMD} 排版小节标题。注意，\tex{subjectCMD} 的定义里，没有使用第 1 个参数，即 \type{#1}，是因为该参数是标题序号，而 \tex{subject} 标题没有序号。

以下示例用于测试主标题与小节标题样式，结果见图 \in[head-test]。

@ 简历标题样式测试 # [typing]
\usemodule[zhfonts]
# 简历参数 @
# 简历样式 @
# 小节标题盒子 @
\startTEXpage[width=10cm,offset=5mm]
\title{某某人}
... ... ...
\subject{能吞下玻璃}
... ... ...
\stopTEXpage
@

\placefigure[here][head-test]{标题样式测试}{\externalfigure[test/03.pdf]}

\section{个人基本信息}

个人基本信息通常是以表格的形式呈现，但若使之简约，需从网络上搜集一些小图标，用以代替部分文字，也可以让 AI 创作。于是，我得到了一些图标，将其存于 \type{icons} 目录，然后定义一些宏，将图标载入充当文字使用。

@ 简历样式 # +
\define[3]\DefSym{%
  \definesymbol
    [#1]
    [{\offset[bottomoffset=#2]{\externalfigure[icons/#1.png][height=#3]}}]
  \expandafter\def\csname cv#1\endcsname##1{\symbol[#1]\ ##1}%
}
\DefSym{birthday}{-.2em}{1.25em} % 生日
\DefSym{sex}{-.1em}{1.2em} % 性别
\DefSym{address}{-.2em}{1.2em} % 地址
\DefSym{education}{-.2em}{1.2em} % 学历
\DefSym{phone}{-.2em}{1.1em} % 电话
\DefSym{mail}{-.2em}{.9em} % 邮箱
\DefSym{im}{-.2em}{1.25em}
@

\noindent\tex{DefSym} 是一个工厂宏，亦即其展开结果包含新宏的定义。例如，\type{\DefSym{mail}} 会生成 \tex{cvmail} 宏的定义。在使用 \tex{DefSym} 宏时，需要注意其参数需要与 \type{icons} 目录里的图片同名，例如若参数为 \type{imn}，则 \type{icons} 目录里的图片必须名为 \type{im.png}。\tex{DefSym} 的第 2 个参数是图标下沉深度，第 3 个参数是图标的高度。

用 \CONTEXT\ 最简单的表格 \type{tabulate} 便可排版基本信息：

@ 我的基本信息 # [typing]
\starttabulate[|l|l|l|l|]
\NC\cvbirthday{\type{xxxx-yy-zz}}\NC\cvsex{男}\NC\cveducation{小学}
\NC\cvaddress{终南山活死人墓}\NC\NR
\NC\cvmail{\kern.1em\type{xxxxx@xxxxx.com}}\NC\cvim{微信：\type{xxxx}}
\NC\cvphone{\kern.2em\type{xxxxxxxxxxx}}\NC\NC\NR
\stoptabulate
@

以下示例用于测试个人信息是否能正确排版，结果如图 \in[basic-info] 所示。

@ 个人信息排版测试 # [typing]
\usemodule[zhfonts]
# 简历参数 @
# 简历样式 @
\startTEXpage[width=17cm,frame=on,offset=5mm]
\title{王重阳}
{\bf 一住行窝几十年，蓬头长日走如颠。海棠亭下重阳子，莲叶舟中太乙仙。\\
     无物可离虚壳外，有人能悟未生前。出门一笑无拘碍，云在西湖月在天。}
\blank[line]
# 我的基本信息 @
\stopTEXpage
@
\placefigure[here][basic-info]{个人基本信息}{\externalfigure[test/04.pdf]}

\section{时间节点}

无论是教育背景，还是工作经历，需要由一些时间节点构成，以单行四列的表格形式排版这部分内容，且内容以粗体呈现：

@ 简历样式 # +
\define[8]\cvstage{%
  \starttabulate[|lw(#1\textwidth)|cw(#3\textwidth)|cw(#5\textwidth)|rw(#7\textwidth)|]
                [unit=0cm,before={\blank[halfline]},after={\blank[halfline]}]
  \NC #2 \NC #4 \NC #6 \NC #8 \NC\NR
  \stoptabulate
}
@

\noindent \tex{cvstage} 需要 8 个参数，第 1、3、5、7 个参数是单元格宽度，宽度值是版心宽度的倍数；第 2、4、6、8 个参数是单元格内容。

时间跨度用箭头表示，数学字体里有箭头可用，但是我用的数学字体，其箭头是 $\rightarrow$，我觉得不好看，故而用 \METAPOST\ 代码画了一个箭头，并将其定义为符号：

@ 简历样式 # +
\definesymbol
  [RightArrow]
  [{\offset[bottomoffset=.1em]{\useMPgraphic{RightArrow}}}]
\startuseMPgraphic{RightArrow}
ahvariant := 1; ahdimple := 1; ahlength := 5pt;
drawarrow (0, 0) -- (5mm, 0) withpen pencircle;
\stopuseMPgraphic
\def\RightArrow{\symbol[RightArrow]}
@

以下代码用于测试 \tex{cvstage} 与 \tex{RightArrow}，所得结果如图 \in[stage-test] 所示。

@ 测试时间节点 # [typing]
\usemodule[zhfonts]
# 简历参数 @
# 简历样式 @
\startTEXpage[width=fit]
\cvstage{.3}{\bf 某年某月 \RightArrow\ 某年某月}{.2}{\bf 全真教}{.1}{\bf 掌教}{.2}{\bf 创作全真剑法}
\stopTEXpage
@
\placefigure[here][stage-test]{时间节点测试}{\externalfigure[test/05.pdf]}

\section{段落和列表}

简历中的普通段落，以两个汉字宽度缩进，行间距设为 1.5 倍正文字号：

@ 简历样式 # +
\setupindenting[first,always,2em]
\setupinterlinespace[line=1.5\bodyfontsize]
@

用 \METAPOST\ 绘制列表项符号，并去掉列表前后以及列表项之间的留白：

@ 简历样式 # +
% width 是列表项左侧符号区域宽度，将其设置为 2em，
% 是为了与段落首行缩进一致。
\setupitemize[1][framesym,nowhite][width=2em]
\definesymbol[framesym][{\offset[bottomoffset=-.1em]{\useMPgraphic{framesym}}}]
\startuseMPgraphic{framesym}
numeric u; path p; color squarecolor;
u := BodyFontSize;
p := fullsquare scaled .625u;
squarecolor := \getvariable{cvlist}{color};
fill p shifted (.2u, -.2u) withcolor darkgray;
fill p withcolor squarecolor;
\stopuseMPgraphic
@

\noindent 列表项符号的颜色默认值设定如下：

@ 简历样式 # +
\setvariables[cvlist][color=darkred]
@

以下代码用于测试列表样式，结果见图 \in[list-test]。

@ 段落和列表样式测试 # [typing]
\usemodule[zhfonts]
# 简历参数 @
\startTEXpage[width=8cm]
# 简历样式 @
... ... 段落内容 ... ...
\startitemize
\item 列表项 1 ... ...
\item 列表项 2 ... ...
\stopitemize
\stopTEXpage
@
\placefigure[here][list-test]{列表样式测试}{\externalfigure[test/06.pdf]}

\section{照片}

个人照片放在简历的压轴环节，但实际上它是简历背景的一部分。照片也放在 icons 目录。在个人基本信息区域，我已在其右侧留出了足够的空区，可以用于放照片。以下代码载入照片，将其裁剪为圆形，放在一个合适的位置上。这个位置需要经过一些试探方可确定，我将其开放为简历参数。

@ 背景里的其他元素 #
% 载入照片
picture photo;
photo := externalfigure "icons/photo.png";
% 确定照片尺寸
numeric f;
f := (bbwidth photo) / (bbheight photo);
photo := photo xysized (3.5cm, 3.5cm / f);
% 裁剪为圆形区域
clip photo to unitcircle scaled 3.5cm;
% 照片定位，需要试探几次，方能找到合适位置
pair photolocation;
photolocation := (\getvariable{photo}{x}, \getvariable{photo}{y});
photo := photo shifted photolocation;
% 只在首页显示照片
if \number\userpagenumber = 1:
    draw photo;
fi;
@

经过一些试探，我将照片默认的位置定义为

@ 简历样式 # +
\setvariables[photo][x=16cm,y=24.25cm]
@

\section{模板}

将前文所作样式汇总为模板文件，以名为 octcv.tex 的文件保存：

@ octcv.tex # [typing]
\startenvironment octcv
\usemodule[zhfonts]
# 简历参数 @
# 简历样式 @
# 简历页面背景 @
# 小节标题盒子 @
\stopenvironment
@

\useURL[xi-prog][https://github.com/liyanrui/xi]
\noindent 使用 \type{xi} 程序\footnote{\from[xi-prog]}可从本文档的源文件 \type{mycv.xi} 中提取 octcv.tex：

\starttyping
$ xi -t -e "octcv.tex" -o octcv.tex mycv.xi
\stoptyping

使用 octcv.tex 的方法是，创建简历源文档，例如 foo.tex：

@ foo.tex # [typing]
\environment oct-cv
\starttext
... 简历内容 ...
\stoptext
@

\noindent 将 octcv.tex 和 foo.tex 放在同一目录，然后使用以下命令编译 foo.tex：

\starttyping
$ context foo.tex
\stoptyping

\section{示例}

@ demo.tex # [typing]
\environment octcv
\starttext
\title{王重阳}
\noindent{\bf 一住行窝几十年，蓬头长日走如颠。海棠亭下重阳子，莲叶舟中太乙仙。\\
     无物可离虚壳外，有人能悟未生前。出门一笑无拘碍，云在西湖月在天。}
\starttabulate[|l|l|l|l|]
\NC\cvbirthday{\type{xxxx-yy-zz}}\NC\cvsex{男}\NC\cveducation{博士}
\NC\cvaddress{终南山全真祖庭}\NC\NR
\NC\cvmail{\kern.1em\type{xxxxx@xxxxx.com}}\NC\cvim{微信：\type{xxxx}}
\NC\cvphone{\kern.2em\type{xxxxxxxxxxx}}\NC\NC\NR
\stoptabulate
\subject{教育背景}
\cvstage{.3}{\tt 1159 \RightArrow\ 1161}{.3}{终南山活死人墓}{.2}{博士}{.2}{道学}
\cvstage{.3}{\tt 1122 \RightArrow\ 1132}{.3}{咸阳某大学}{.2}{武举甲科}{.2}{儒学}
\subject{工作经历}
\cvstage{.3}{\tt 1167 \RightArrow\ 1170}{.3}{山东}{.2}{全真教}{.2}{教主}
\startitemize
\item 撰写《重阳立教十五论》；
\item 收马丹阳、谭处端、刘处玄、丘处机、王处一、郝大通、孙不二为徒
\item 建立三教七宝会、金莲会、三光会、玉华会等。
\stopitemize
\stoptext
@
\placefigure[here][photo-test]{王重阳的简历}{\externalfigure[test/07.png][width=\textwidth]}

\stoptext