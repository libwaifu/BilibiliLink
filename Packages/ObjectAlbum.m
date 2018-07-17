BilibiliAlbumObject::usage = "内部函数, 图片地址对象.";
BilibiliLink`ㄑAlbum::usage = "";
BilibiliLink`ㄑAlbum[___] := "";
Begin["`Object`"];
(*BilibiliAlbumObject*)
BilibiliAlbumObjectQ::usage = "BilibiliAlbumObject 合法性检测";
BilibiliAlbumObjectQ[asc_?AssociationQ] := AllTrue[{"Count", "Date"}, KeyExistsQ[asc, #]&];
BilibiliAlbumObjectQ[_] := False;

Format[BilibiliAlbumObjectQ[___], OutputForm] := "BilibiliDownloadObject[>_<]";
Format[BilibiliAlbumObjectQ[___], InputForm] := "BilibiliDownloadObject[>_<]";
BilibiliAlbumObject /: MakeBoxes[obj : BilibiliAlbumObject[asc_?BilibiliAlbumObjectQ], form : (StandardForm | TraditionalForm)] := Module[
	{above, below},
	above = {
		{BoxForm`SummaryItem[{"Type: ", "PicturesPack"}]},
		{BoxForm`SummaryItem[{"Category: ", asc["Category"]}]},
		{BoxForm`SummaryItem[{"Date: ", DateString[asc["Date"]]}]},
		{BoxForm`SummaryItem[{"Repo: ", asc["Repo"]}]},
		{BoxForm`SummaryItem[{"Count: ", asc["Count"]}]},
		{BoxForm`SummaryItem[{"Size: ", AlbumSizeConvert[asc["Size"]]}]},
		{BoxForm`SummaryItem[{"Time: ", asc["Time"]}]}
	};
	below = {};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink", obj,
		$BilibiliLinkIcons["BilibiliAlbumObject"],
		above, below, form,
		"Interpretable" -> Automatic
	]
];
(*Aid Functions*)
AlbumSizeConvert[x_Integer] := N@Piecewise[{
	{Quantity[x, "Kilobytes"], x < 1024 / 2},
	{Quantity[x / 1024, "Megabytes"], 1024^2 / 2 > x >= 1024 / 2},
	{Quantity[x / 1024^2, "Gigabytes"], x >= 1024^2 / 2}
}];
Options[ImageSizeConvert] = {Format -> "webp"};
ImageSizeConvert[size_, OptionsPattern[]] := Switch[
	size,
	Tiny, "@125w_125h_1e." <> OptionValue[Format],
	Small, "@250w_250h_1e." <> OptionValue[Format],
	Normal, "@500w_500h_1e." <> OptionValue[Format],
	Large, "@1000w_1000h_1e." <> OptionValue[Format],
	RawData, "",
	_, size
];
MapMonitored[f_, args_List] := Module[
	{x = 0},
	Monitor[
		MapIndexed[(x = #2[[1]];f[#1])&, args],
		ProgressIndicator[x / Length[args]]
	]
];




(*Interface*)
BilibiliAlbumObject[ass_][func_String] := Switch[
	func,
	"d", BilibiliAlbumObject[ass]["Data"],
	"Data", Lookup[ass, "Data"],
	"i", BilibiliAlbumObject[ass]["Image"],
	"Image", Flatten["imgs" /. Lookup[ass, "Data"]],
	"m", BilibiliAlbumObject[ass]["Markdown"],
	"Markdown", PicturesPackMarkdownExport[ass],
	"do", AlbumDownload[ass]["Download"],
	"Download", AlbumDownload[ass],
	_, BilibiliAlbumObjectHelp[]
];
BilibiliAlbumObject[ass_][func_String, {para__}] := Switch[
	func,
	"Download", AlbumDownload[ass, para],
	_, BilibiliAlbumObjectHelp[]
];
BilibiliAlbumObject[ass_][___] := BilibiliAlbumObjectHelp[];


(*Method*)
PicturesPackMarkdownExport[ass_] := Block[
	{text = PicturesPack2MD[Lookup[ass, "Data"]], name, file},
	name = DateString[Lookup[ass, "Date"], {"Year", "-", "Month", "-", "Day", "-"}] <> ToString[Hash@text] <> ".md";
	file = FileNameJoin[{$BilibiliLinkData, "Markdown", name}];
	If[FileExistsQ[file], Return[file], CreateFile[file]];
	Export[file, text, "Text"]
];
PicturesPack2MD::usage = "将Album对象中的数据导出为Markdown格式.";
PicturesPack2MD[docs_List] := StringJoin[PicturesPack2MD /@ docs];
PicturesPack2MD[doc_Association] := StringJoin@Riffle[Join[
	{
		"### 作者: " <> doc["author"],
		"### 主页: " <> "https://space.bilibili.com/" <> ToString[doc["uid"]] <> "/#/album",
		"### 标题: " <> doc["title"],
		"### 日期: " <> DateString@doc["time"],
		"### 链接: " <> "https://h.bilibili.com/" <> ToString[doc["did"]]
	},
	"![](" <> # <> ")"& /@ doc["imgs"],
	{"\r---\r\r"}
], "\r"];

Options[AlbumCollage] = {
	Max -> 25,
	ItemSize -> Small,
	ImageSize -> Automatic,
	AspectRatio -> GoldenRatio
};
AlbumCollage[ass_, OptionsPattern[]] := Module[
	{imgs, get, fliter, $now = Now, ar = OptionValue[AspectRatio]},
	imgs = RandomSample[Flatten["imgs" /. ass["Data"]], UpTo[OptionValue[Max]]];
	get = MapMonitored[URLExecute[# <> ImageSizeConvert[OptionValue[ItemSize]]]&, imgs];
	fliter = Select[get, 1 / ar < ImageAspectRatio[#] < ar&];
	Echo[Now - $now, "Time Used:"];
	ImageCollage[fliter, Background -> Transparent, Method -> "Rows", ImageSize -> OptionValue[ImageSize]]
];
Options[AlbumDownload] = {
	ImageSize -> RawData,
	Format -> "webp",
	Path -> FileNameJoin[{$BilibiliLinkData, "Image", ass["Category"]}]
};
AlbumDownload[ass_, OptionsPattern[]] := Module[
	{data},
	data = Function[doc,
		<|"Name" -> Last@StringSplit[#, "/"], "URL" -> #|>& /@
			(# <> ImageSizeConvert[OptionValue[ImageSize], Format -> OptionValue[Format]]& /@ doc["imgs"])
	][Flatten[reshape /@ ass["Data"]]];
	BilibiliDownloadObject[<|
		"Date" -> ass["Date"],
		"Category" -> ass["Category"],
		"Data" -> data,
		"Path" -> OptionValue[Path],
		"Size" -> ass["Size"]
	|>]
];



SetAttributes[
	{},
	{Protected, ReadProtected}
];
End[]
