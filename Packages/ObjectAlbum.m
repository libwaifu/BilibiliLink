BilibiliAlbumObject::ussage="内部函数, 图片地址对象.";
Begin["`Object`"];
(*BilibiliAlbumObject*)
BilibiliAlbumObjectQ::ussage="BilibiliAlbumObject 合法性检测";
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
	"Markdown",PicturePack2MD[ass],
	"do",AlbumDownload[ass],
	"Download",AlbumDownload[ass],
	_,BilibiliPicturePackHelp[]
];
BilibiliAlbumObject[ass_][func_String,{para__}]:=Switch[
	func,
	"do",AlbumDownload[ass,para],
	"Download",AlbumDownload[ass,para],
	_,BilibiliPicturePackHelp[]
];
BilibiliAlbumObject[ass_][___]:=BilibiliPicturePackHelp[];


(*Method*)
AlbumDownload[raw_]:=Switch[
	raw["Data","DataType"],
	"AlbumIndexPage",AlbumIndexPageDownload[raw]



];



Options[AlbumIndexPageDownload]={ImageSize->Full,Defer->False};
AlbumIndexPageDownload[ass_,OptionsPattern[]]:=Block[
	{size=OptionValue[ImageSize],obj,resize},
	resize=<|"Name"->#["Name"]<>ToString[size],"URL"->#["URL"]<>ImageSizeConvert[size]|>&;
	obj=BilibiliDownloadObject[<|
		"Date"->ass["Date"],
		"Category"->ass["Data","DataType"],
		"Data"->(resize/@ass["Data","ImageList"]),
		"Path"->FileNameJoin[{$BilibiliLinkData,"Image","Album","Index"}],
		"Size"->Quantity[ass["Size"]/1024.,"Megabytes"]
	|>];
	If[OptionValue[Defer],Return[obj],obj["Download"]]
]



End[]