
BilibiliArticle::usage = "将HTML转化为Markdown格式.";
(* ::Section:: *)
(*程序包正体*)
Begin["`Columns`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*下载并转化专栏*)
Options[BilibiliArticle]={Debug->False};
BilibiliArticle[cv_,OptionsPattern[]]:=Block[
	{xml,pre,body,
		raw=Import["https://www.bilibili.com/read/cv"<>ToString@cv,{"HTML","XMLObject"}]
	},
	xml=Flatten@Cases[raw,XMLElement["div",{"class"->"article-holder"},t___]:>t,Infinity,1];
	pre=xml/.{
		XMLElement["h1",{},{h__}]:>StringJoin["\n# ",h,"\n"],
		XMLElement["h2",{},{h__}]:>StringJoin["\n## ",h,"\n"],
		XMLElement["h3",{},{h__}]:>StringJoin["\n### ",h,"\n"],
		XMLElement["h4",{},{h__}]:>StringJoin["\n#### ",h,"\n"],
		XMLElement["h5",{},{h__}]:>StringJoin["\n##### ",h,"\n"],
		XMLElement["h6",{},{h__}]:>StringJoin["\n###### ",h,"\n"],
		XMLElement["strong",{},{b_}]:>StringJoin["**",b,"**"],(*粗体标识*)
		XMLElement["div",___,{text___}]:>text,
		XMLElement["figure",err___]:>Nothing,(*错误解析, 直接删除*)
		XMLElement["figcaption",err___]:>Nothing,(*错误解析, 直接删除*)
		XMLElement["img",{"data-src"->img_,__},{}]:>StringJoin["![](",img,")"],
		XMLElement["img",{"class"->_,"data-src"->img_},{}]:>StringJoin["![](",img,")"],
		XMLElement["img",{"class"->"video-card nomal","data-src"->img_,__,"aid"->aid_,__},{}]:>StringTemplate[
			"[![](`img`)](www.bilibili.com/blackboard/player.html?aid=`aid`)"
		][<|"img"->img,"aid"->aid|>],
		XMLElement["hr",___]:>"\n---\n"
	};
	body=pre/.{
		XMLElement["p",{},{para___}]:>StringJoin["\n",para,"\n"],(*段落标识*)
		XMLElement["blockquote",{},q_]:>StringJoin@Riffle[q,"> ",{1,-1,3}],
		XMLElement["ul",{},{ul__}]:>StringJoin["\n",ul,"\n"],
		XMLElement["li",{},{li__}]:>StringJoin["> ",li,"\n"]
	};
	If[OptionValue[Debug],Return[body],StringJoin[ToString/@body]]
];
(*(*读入预处理*)
	text=URLExecute["https://www.bilibili.com/read/cv423670","Text",CharacterEncoding->"UTF8"];
	raw=ImportString[StringReplace[text,Thread[{"span","br"}->"div"]],{"HTML","XMLObject"}];
*)
(*(*span替换*)
$ColorMapArticle=<|
	"color-blue-01"\[Rule]"#56c1fe","color-lblue-01"\[Rule]"#73fdea","color-green-01"\[Rule]"#89fa4e","color-yellow-01"\[Rule]"#fff359","color-pink-01"\[Rule]"#ff968d","color-purple-01"\[Rule]"#ff8cc6","color-blue-02"\[Rule]"#02a2ff","color-lblue-02"\[Rule]"#18e7cf","color-green-02"\[Rule]"#60d837","color-yellow-02"\[Rule]"#fbe231","color-pink-02"\[Rule]"#ff654e","color-purple-02"\[Rule]"#ef5fa8","color-blue-03"\[Rule]"#0176ba","color-lblue-03"\[Rule]"#068f86","color-green-03"\[Rule]"#1db100","color-yellow-03"\[Rule]"#f8ba00","color-pink-03"\[Rule]"#ee230d","color-purple-03"\[Rule]"#cb297a","color-blue-04"\[Rule]"#004e80","color-lblue-04"\[Rule]"#017c76","color-green-04"\[Rule]"#017001","color-yellow-04"\[Rule]"#ff9201","color-pink-04"\[Rule]"#b41700","color-purple-04"\[Rule]"#99195e","color-gray-01"\[Rule]"#d6d5d5","color-gray-02"\[Rule]"#929292","color-gray-03"\[Rule]"#5f5f5f","color-default"\[Rule]"#222"
|>;
XMLElement["span",{"class"\[Rule]class_},{text_}]\[RuleDelayed]StringTemplate[
	"<font color=`color`>`text`</font>"][Association[
	"color"\[Rule]First[StringSplit["color-pink-03 font-size-20"," "]/.\[VeryThinSpace]$ColorMapArticle]],"text"\[Rule]text
]
*)

(* ::Subsection::Closed:: *)
(*附加设置*)
SetAttributes[
	{},
	{Protected,ReadProtected}
];
End[]