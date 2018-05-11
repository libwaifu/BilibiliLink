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
		N@Quantity[Total["img_size"/.doc["item","pictures"]],"Megabytes"],
		Missing
	]
|>;
$PhotoMap=<|"Cosplay"->"cos","其他服饰"->"sifu","插画"->"illustration","漫画"->"comic","其他画作"->"draw","全部画作"->"all"|>;
PhotosLeaderboard[cat_]:=Module[
	{$now=Now,raw,data},
	raw=URLExecute[HTTPRequest[#,TimeConstraint->10],"RawJSON"]["data","items"]&/@$APIs["hot"][$PhotoMap[cat]];
	data=PictureDataRebuild/@Flatten[raw];
	PicturesPack[<|
		"data"->data,
		"Category"->Text@cat,
		"Repo"->Length@data,
		"Count"->Length@Flatten["imgs"/.data],
		"Size"->Total@DeleteCases["size"/.data,Missing],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];


SetAttributes[
	{},
	{Protected,ReadProtected}
];
End[];
