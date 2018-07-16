BilibiliDownload::usage = "";
BilibiliDownloadObject::usage = ToString[Column[{
	Row[{"初始化下载对象, ",Style["obj = BilibiliLink[...,Type->DownloadObject]",Blue]}],
	Row[{Style["\t快速下载: ",Bold],"obj@\"do\""}],
	Row[{Style["\t转换为md格式: ",Bold],"obj@\"m\""}],
	Row[{Style["\t提取原始数据: ",Bold],"obj@\"d\""}],
	Row[{Style["完整指令: ",Red,Bold],"简令: 指令 - 函数"}],
	"\td: Data",
	"\tm: MarkDown",
	"\tdo: Download - BilibiliDownload"
}],StandardForm];
BilibiliLink`§Download::usage = "";
BilibiliLink`§Download[___] := "";
Begin["`Object`"];
BilibiliDownloadObjectQ::usage = "BilibiliDownloadObject 合法性检测";
BilibiliDownloadObjectQ[asc_?AssociationQ] := AllTrue[{"Path", "Data"}, KeyExistsQ[asc, #]&];
BilibiliDownloadObjectQ[_] := False;
Format[BilibiliDownloadObject[___], OutputForm] := "BilibiliDownloadObject[<>]";
Format[BilibiliDownloadObject[___], InputForm] := "BilibiliDownloadObject[<>]";
BilibiliDownloadObject /: MakeBoxes[obj : BilibiliDownloadObject[asc_?BilibiliDownloadObjectQ], form : (StandardForm | TraditionalForm)] := Module[
	{above, below},
	above = {
		{BoxForm`SummaryItem[{"Type: ", "DownloadObject"}]},
		{BoxForm`SummaryItem[{"Category: ", asc["Category"]}]},
		{BoxForm`SummaryItem[{"Count: ", Length@asc["Data"]}]},
		{BoxForm`SummaryItem[{"Size: ", DownloadSizeConvert[asc["Size"]]}]}
	};
	below = {
		{BoxForm`SummaryItem[{"Date: ", DateString[asc["Date"]]}]},
		{BoxForm`SummaryItem[{"Path: ", File[asc["Path"]]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink", obj,
		$BilibiliLinkIcons["BilibiliDownloadObject"],
		above, below, form,
		"Interpretable" -> Automatic
	]
];

(*Aid Functions*)
DownloadSizeConvert[x_] := N@Piecewise[{
	{Quantity[x / 1024^0, "Bytes"], x < 1024 / 2},
	{Quantity[x / 1024^1, "Kilobytes"], 1024^2 / 2 > x >= 1024^1 / 2},
	{Quantity[x / 1024^2, "Megabytes"], 1024^3 / 2 > x >= 1024^2 / 2},
	{Quantity[x / 1024^3, "Gigabytes"], x >= 1024^3 / 2}
}];


BilibiliDownloadObject[ass_][func_String] := Switch[
	func,
	"do", BilibiliDownload[ass],
	"Download", BilibiliDownload[ass],
	"d", Dataset[ass["Data"]],
	"Data", Dataset[ass["Data"]],
	_, Information[BilibiliDownloadObject]
];
BilibiliDownloadObject[ass_][func_String, {para__}] := Switch[
	func,
	"Download", BilibiliDownload[ass, para],
	_, Information[BilibiliDownloadObject]
];
BilibiliDownloadObject[ass_][___] := BilibiliDownloadHelp[];

BilibiliDownload[BilibiliDownloadObject[ass_]] := BilibiliDownload[ass];


Options[BilibiliDownloadLine] = {Path -> $TemporaryDirectory, Method -> URLDownloadSubmit};
BilibiliDownloadLine[line_, OptionsPattern[]] := Block[
	{path = OptionValue[Path], file},
	file = FileNameJoin[{path, line["Name"] <> "." <> Last@StringSplit[line["URL"], "."]}];
	If[FileExistsQ@file, Return[]];
	OptionValue[Method][line["URL"], file]
];
Options[BilibiliDownload] = {
	Path -> Automatic,
	Method -> URLDownloadSubmit,
	Return -> True
};
BilibiliDownload[ass_, OptionsPattern[]] := Block[
	{data = ass["Data"], path},
	path = If[OptionValue[Path] == Automatic, ass["Path"], OptionValue[Path]];
	If[!FileExistsQ[path], CreateDirectory[path]];
	BilibiliDownloadLine[#, Path -> path, Method -> OptionValue[Method]]& /@ data;
	If[OptionValue[Return], Return[ass["Path"]]];
];



End[]
