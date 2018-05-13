BilibiliVideoSectionObject::ussage="";
Begin["`Object`"];
BilibiliVideoSectionObjectQ::ussage="BilibiliVideoSectionObject 合法性检测";
BilibiliVideoSectionObjectQ[asc_?AssociationQ]:=AllTrue[{"Me","Parent","Count","Date"},KeyExistsQ[asc,#]&];
BilibiliVideoSectionObjectQ[_]=False;
Format[BilibiliVideoSectionObject[___],OutputForm]:="BilibiliVideoSectionObject[<>]";
Format[BilibiliVideoSectionObject[___],InputForm]:="BilibiliVideoSectionObject[<>]";
BilibiliVideoSectionObject/:MakeBoxes[obj:BilibiliVideoSectionObject[asc_?BilibiliVideoSectionObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"Type: ","VideoSection"}]},
		{BoxForm`SummaryItem[{"Section: ",asc["Me"]["name"]}]},
		{BoxForm`SummaryItem[{"Link: ",Hyperlink[StringSplit[#["url"],{"/","."}][[-2]],#["url"]]&[asc["Me"]]}]}
	};
	below={
		{BoxForm`SummaryItem[{"Count: ",asc["Count"]}]},
		{BoxForm`SummaryItem[{"Parent: ",Hyperlink[#["name"],#["url"]]&[asc["Parent"]]}]},
		{BoxForm`SummaryItem[{"Date: ",DateString[asc["Date"]]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",
		obj,
		$BilibiliLinkIcons["BilibiliVideoSectionObject"],
		above,
		below,
		form,
		"Interpretable"->Automatic]
];
SetAttributes[
	{BilibiliVideoSectionObject},
	{Protected,ReadProtected}
];
End[];
(* BilibiliVideoSectionObjectExample=<|
	"Me"-><|"name"->"MAD\[CenterDot]AMV","url"->"http://www.bilibili.com/video/douga-mad-1.html","parent"->1|>,
	"Parent"-><|"name"->"动画","url"->"http://www.bilibili.com/video/douga.html","parent"->0|>,
	"Count"->224270,
	"Date"->DateObject[{2018, 5, 12, 16, 0, 0}, "Instant", "Gregorian", 8]
|>*)