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

PhotosLeaderboard::ussage="h.bilibili.com 图片作品排行榜.";
(* ::Section:: *)
(*程序包正体*)
Begin["`Photos`"];


BilibiliAlbumIndex[]:=Module[
	{$now=Now,get,bg,imgs,data},
	get=URLExecute[$PhotosAPI["Home"],"RawJSON"]["data"];
	bg=<|"Name"->ToString[Now//UnixTime]<>"_0","URL"->get["bg_img"]|>;
	imgs=MapIndexed[<|"Name"->StringJoin[ToString/@{UnixTime@Now,_,First@#2}],"URL"->#1|>&,"img_src"/.get["items"]];
	data=<|
		"DataType"->"AlbumIndexPage",
		"ImageList"->Prepend[imgs,bg]
	|>;
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"Album Index Page",
		"Repo"->Length[get["items"]]+1,
		"Count"->Length[get["items"]]+1,
		"Size"->Total@Select["img_size"/.get["items"],IntegerQ],
		"Time"->Now-$now,
		"Date"->$now
	|>]
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
		Quantity[Total["img_size"/.doc["item","pictures"]]/1024.0,"Megabytes"],
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
	BilibiliPicturePackObject[<|
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



PicturePack2MD[ass_]:=Block[
	{text = PicturesPack2MD[Lookup[ass, "Data"]], name, file},
	name = DateString[Lookup[ass, "Date"], {"Year", "-", "Month", "-", "Day", "-"}] <>ToString[Hash@text] <> ".md";
	file = FileNameJoin[{$BilibiliLinkData, "Markdown", name}];
	If[FileExistsQ[file],Message[BilibiliExport::NoFile, name];Return[file],CreateFile[file]];
	Export[file, text, "Text"]
];


SetAttributes[
	{},
	{Protected,ReadProtected}
];
End[];
