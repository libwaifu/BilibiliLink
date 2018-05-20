
BilibiliDownloadObject::ussage="BilibiliDownloadObject 合法性检测";
Begin["`Object`"];
BilibiliDownloadObjectQ::ussage="BilibiliDownloadObject 合法性检测";
BilibiliDownloadObjectQ[asc_?AssociationQ]:=AllTrue[{"Data","Path","Size"},KeyExistsQ[asc,#]&]
BilibiliDownloadObjectQ[_]=False;
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
		{BoxForm`SummaryItem[{"Path: ",asc["Path"]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",obj,
		$BilibiliLinkIcons["BilibiliDownloadObject"],
		above,below,form,
		"Interpretable"->Automatic
	]
];




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
End[]