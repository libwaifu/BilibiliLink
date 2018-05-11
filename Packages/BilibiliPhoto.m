(* ::Package:: *)
(* ::Title:: *)
(*BilibiliColumns*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(**)
(* ::Text:: *)
(*Creation Date: 2018-03-12*)
(*Copyright: Mozilla Public License Version 2.0*)
(* ::Program:: *)
(*1.软件产品再发布时包含一份原始许可声明和版权声明。*)
(*2.提供快速的专利授权。*)
(*3.不得使用其原始商标。*)
(*4.如果修改了源代码，包含一份代码修改说明。*)
(* ::Section:: *)
(*函数说明*)
PicturesPack::ussage="内部函数, 图片地址对象.";
PhotosLeaderboard::ussage="h.bilibili.com 图片作品排行榜.";
BilibiliExport::NoFile = "`1` 已存在";
(* ::Section:: *)
(*程序包正体*)
Begin["`Photos`"];
(* ::Subsection::Closed:: *)
(*PicturesPackPbject*)
PicturesPackQ::ussage="PicturesPack 合法性检测";

PicturesPackQ[asc_?AssociationQ] := AllTrue[{"Date","Count"}, KeyExistsQ[asc, #]&]
PicturesPackQ[_] = False;
Format[PicturesPack[___],OutputForm]:="PicturesPack[<>]";
Format[PicturesPack[___],InputForm]:="PicturesPack[<>]";
PicturesPack/:MakeBoxes[obj:PicturesPack[asc_?PicturesPackQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"Type: ", "PicturesPack"}]},
		{BoxForm`SummaryItem[{"Category: ", asc["Category"]}]},
		{BoxForm`SummaryItem[{"Repo: ", asc["Repo"]}]},
		{BoxForm`SummaryItem[{"Count: ", asc["Count"]}]},
		{BoxForm`SummaryItem[{"Size: ", asc["Size"]}]},
		{BoxForm`SummaryItem[{"Time: ", asc["Time"]}]},
		{BoxForm`SummaryItem[{"Date: ", DateString[asc["Date"]]}]}
	};
	below = {};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",
		obj,
		$BilibiliLinkIcons["PicturesPack"],
		above,
		below,
		form,
		"Interpretable" -> Automatic
	]
];
PicturesPack[ass_]["Data"]:=Lookup[ass,"Data"];
PicturesPack[ass_]["Image"]:=Flatten["imgs"/.Lookup[ass,"Data"]];
PicturesPack[ass_]["Markdown"]:=Module[
	{text = PicturesPack2MD[Lookup[ass, "Data"]], name, file},
	name = DateString[Lookup[ass, "Date"], {"Year", "-", "Month", "-", "Day", "-"}] <>ToString[Hash@text] <> ".md";
	file = FileNameJoin[{$BilibiliLinkData, "Markdown", name}];
	If[FileExistsQ[file],Message[BilibiliExport::NoFile, name];Return[file],CreateFile[file]];
	Export[file, text, "Text"]
];





(* ::Subsection::Closed:: *)
(*PhotosLeaderboard*)
PictureDataRebuild::ussage="内部函数, 用于数据清洗";
PictureDataRebuild[doc_Association]:=<|
	"uid"->doc["user","uid"],
	"author"->doc["user","name"],
	"did"->doc["item","doc_id"],
	"title"->doc["item","title"],
	"time"->FromUnixTime[doc["item","upload_time"]],
	"imgs"->("img_src"/.doc["item","pictures"]),
	"size"->If[KeyExistsQ[First@doc["item","pictures"],"img_size"],
		N@Quantity[Total["img_size"/.doc["item","pictures"]]/1024,"Megabytes"],
		Missing
	]
|>;
$PhotoMap=<|"Cosplay"->"cos","其他服饰"->"sifu","插画"->"illustration","漫画"->"comic","其他画作"->"draw","全部画作"->"all"|>;
PhotosLeaderboard[cat_]:=Module[
	{$now=Now,map,raw,data},
	map=Switch[cat,
		"Cosplay",$APIs["PhotoHot"]["cos"],
		"其他服饰",$APIs["PhotoHot"]["sifu"],
		"插画作品",$APIs["PhotoHot"]["illustration"],
		"漫画作品",$APIs["PhotoHot"]["comic"],
		"其他画作",$APIs["PhotoHot"]["draw"],
		"全部画作",$APIs["PhotoHot"]["all"],
		"日榜",$APIs["PhotoRank"]["day"],
		"周榜",$APIs["PhotoRank"]["week"],
		"月榜",$APIs["PhotoRank"]["month"],
		_,Echo[Text@"可选参数:Cosplay,其他服饰,插画作品,漫画作品,其他画作,全部画作,日榜,周榜,月榜"];Return[$Failed]
	];
	raw=URLExecute[HTTPRequest[#,TimeConstraint->10],"RawJSON"]["data","items"]&/@map;
	data=PictureDataRebuild/@Flatten[raw];
	PicturesPack[<|
		"Data"->data,
		"Category"->Text@cat,
		"Repo"->Length@data,
		"Count"->Length@Flatten["imgs"/.data],
		"Size"->Total@DeleteCases["size"/.data,Missing],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];
PicturesPack2MD[doc_Association]:=StringJoin@Riffle[Join[
	{
		"### 作者: "<>doc["author"],
		"### 主页: "<>"https://space.bilibili.com/"<>ToString[doc["uid"]]<>"/#/album",
		"### 标题: "<>doc["title"],
		"### 日期: "<>DateString@doc["time"],
		"### 链接: "<>"https://h.bilibili.com/"<>ToString[doc["did"]]
	},
	"![]("<>#<>")"&/@doc["imgs"],
	{"\r---\r\r"}
],"\r"];
PicturesPack2MD[docs_List]:=StringJoin[PicturesPack2MD/@docs];





SetAttributes[
	{},
	{Protected,ReadProtected}
];
End[];
