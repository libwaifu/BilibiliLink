BilibiliAlbumObject::usage="内部函数, 图片地址对象.";
Begin["`Object`"];
(*BilibiliAlbumObject*)
BilibiliAlbumObjectQ::usage="BilibiliAlbumObject 合法性检测";
BilibiliAlbumObjectQ[asc_?AssociationQ]:=AllTrue[{"Count","Date"},KeyExistsQ[asc,#]&];
BilibiliAlbumObjectQ[_]:=False;

Format[BilibiliDownloadObject[___],OutputForm]:="BilibiliDownloadObject[>_<]";
Format[BilibiliDownloadObject[___],InputForm]:="BilibiliDownloadObject[>_<]";
BilibiliAlbumObject/:MakeBoxes[obj:BilibiliAlbumObject[asc_?BilibiliAlbumObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"Type: ","PicturesPack"}]},
		{BoxForm`SummaryItem[{"Category: ",asc["Category"]}]},
		{BoxForm`SummaryItem[{"Date: ",DateString[asc["Date"]]}]},
		{BoxForm`SummaryItem[{"Repo: ",asc["Repo"]}]},
		{BoxForm`SummaryItem[{"Count: ",asc["Count"]}]},
		{BoxForm`SummaryItem[{"Size: ",SizeConvert[asc["Size"]]}]},
		{BoxForm`SummaryItem[{"Time: ",asc["Time"]}]}
	};
	below={};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",obj,
		$BilibiliLinkIcons["BilibiliAlbumObject"],
		above,below,form,
		"Interpretable"->Automatic]
];
(*Aid Functions*)
SizeConvert[x_Integer]:=N@Piecewise[{
	{Quantity[x, "Kilobytes"],x<1024/2},
	{Quantity[x/1024,"Megabytes"],1024^2/2>x>=1024/2},
	{Quantity[x/1024^2,"Gigabytes"],x>=1024^2/2}
}];
ImageSizeConvert[size_]:=Switch[
	size,
	Tiny,"@125w_125h_1e.webp",
	Small,"@125w_125h_1e.webp",
	Normal,"@125w_125h_1e.webp",
	Large,"@125w_125h_1e.webp",
	Full,"",
	__,""
];





(*Interface*)
BilibiliAlbumObject[ass_][func_String]:=Switch[
	func,
	"Data",Lookup[ass,"Data"],
	"Image",Flatten["imgs"/.Lookup[ass,"Data"]],
	"Markdown",PicturesPackMarkdownExport[ass],
	"do",AlbumDownload[ass],
	"Download",AlbumDownload[ass],
	_,BilibiliAlbumObject[]
];
BilibiliAlbumObject[ass_][func_String,{para__}]:=Switch[
	func,
	"do",AlbumDownload[ass,para],
	"Download",AlbumDownload[ass,para],
	_,BilibiliAlbumObject[]
];
BilibiliAlbumObject[ass_][___]:=BilibiliAlbumObject[];


(*Method*)
PicturesPackMarkdownExport[ass_]:=Block[
	{text = PicturesPack2MD[Lookup[ass, "Data"]], name, file},
	name = DateString[Lookup[ass, "Date"], {"Year", "-", "Month", "-", "Day", "-"}] <>ToString[Hash@text] <> ".md";
	file = FileNameJoin[{$BilibiliLinkData, "Markdown", name}];
	If[FileExistsQ[file],Message[BilibiliExport::NoFile, name];Return[file],CreateFile[file]];
	Export[file, text, "Text"]
];

PicturesPack2MD[docs_List]:=StringJoin[PicturesPack2MD/@docs];

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



End[]