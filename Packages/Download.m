










BilibiliDownload::ussage="xxx";
Begin["`Download`"];
Options[BilibiliDownloadLine]={Path->$TemporaryDirectory,Method->URLDownloadSubmit};
BilibiliDownloadLine[line_,OptionsPattern[]]:=Block[
	{path=OptionValue[Path],file},
	file=FileNameJoin[{path,line["Name"]<>"."<>Last@StringSplit[line["URL"],"."]}];
	If[FileExistsQ@file,Return[]];
	OptionValue[Method][line["URL"],file]
];

BilibiliDownload[ass_]:=Block[
	{path=ass["Path"],data=ass["Data"]},
	If[!FileExistsQ[path],CreateDirectory[path]];
	BilibiliDownloadLine[#,Path->path]&/@data;
];
End[];