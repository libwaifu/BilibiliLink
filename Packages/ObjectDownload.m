BilibiliDownload::usage="";
BilibiliDownloadObject::usage="";
Begin["`Object`"];
BilibiliDownloadObjectQ::usage="BilibiliDownloadObject 合法性检测";
BilibiliDownloadObjectQ[asc_?AssociationQ]:=AllTrue[{"Path","Data"},KeyExistsQ[asc,#]&];
BilibiliDownloadObjectQ[_]:=False;
Format[BilibiliDownloadObject[___],OutputForm]:="BilibiliDownloadObject[<>]";
Format[BilibiliDownloadObject[___],InputForm]:="BilibiliDownloadObject[<>]";
BilibiliDownloadObject/:MakeBoxes[obj:BilibiliDownloadObject[asc_?BilibiliDownloadObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"Type: ","DownloadObject"}]},
		{BoxForm`SummaryItem[{"Category: ",asc["Category"]}]},
		{BoxForm`SummaryItem[{"Count: ",Length@asc["Data"]}]},
		{BoxForm`SummaryItem[{"Size: ",asc["Size"]}]}
	};
	below={
		{BoxForm`SummaryItem[{"Date: ",DateString[asc["Date"]]}]},
		{BoxForm`SummaryItem[{"Path: ",File[asc["Path"]]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",obj,
		$BilibiliLinkIcons["BilibiliDownloadObject"],
		above,below,form,
		"Interpretable"->Automatic
	]
];

(*Aid Functions*)
SizeConvert[x_Integer]:=N@Piecewise[{
	{Quantity[x, "Kilobytes"],x<1024/2},
	{Quantity[x/1024,"Megabytes"],1024^2/2>x>=1024/2},
	{Quantity[x/1024^2,"Gigabytes"],x>=1024^2/2}
}];


BilibiliDownloadObject[ass_][func_String]:=Switch[
	func,
	"do",BilibiliDownload[ass],
	"Download",BilibiliDownload[ass],
	"Data",Dataset[ass["Data"]],
	_,BilibiliDownloadHelp[]
];
BilibiliDownloadObject[ass_][func_String,{para__}]:=Switch[
	func,
	"do",BilibiliDownload[ass,para],
	"Download",BilibiliDownload[ass,para],
	_,BilibiliDownloadHelp[]
];
BilibiliDownloadObject[ass_][___]:=BilibiliDownloadHelp[];

BilibiliDownload[BilibiliDownloadObject[ass_]]:=BilibiliDownload[ass];


Options[BilibiliDownloadLine]={Path->$TemporaryDirectory,Method->URLDownloadSubmit};
BilibiliDownloadLine[line_,OptionsPattern[]]:=Block[
	{path=OptionValue[Path],file},
	file=FileNameJoin[{path,line["Name"]<>"."<>Last@StringSplit[line["URL"],"."]}];
	If[FileExistsQ@file,Return[]];
	OptionValue[Method][line["URL"],file]
];
Options[BilibiliDownload]={
	Path->Automatic,
	Method->URLDownloadSubmit,
	Return->True
};
BilibiliDownload[ass_,OptionsPattern[]]:=Block[
	{data=ass["Data"],path},
	path=If[OptionValue[Path]==Automatic,ass["Path"],OptionValue[Path]];
	If[!FileExistsQ[path],CreateDirectory[path]];
	BilibiliDownloadLine[#,Path->path,Method->OptionValue[Method]]&/@data;
	If[OptionValue[Return],Return[ass["Path"]]];
];



End[]