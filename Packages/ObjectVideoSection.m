BilibiliVideoSectionObject::usage = "";
BilibiliLink`§VideoSectionObject::usage = "";
BilibiliLink`§VideoSectionObject[___] := "";
Begin["`Object`"];
BilibiliVideoSectionObjectQ::usage = "BilibiliVideoSectionObject 合法性检测";
BilibiliVideoSectionObjectQ[asc_?AssociationQ] := AllTrue[{"Me", "Parent", "Count", "Date"}, KeyExistsQ[asc, #]&];
BilibiliVideoSectionObjectQ[_] = False;
Format[BilibiliVideoSectionObject[___], OutputForm] := "BilibiliVideoSectionObject[<>]";
Format[BilibiliVideoSectionObject[___], InputForm] := "BilibiliVideoSectionObject[<>]";
BilibiliVideoSectionObject /: MakeBoxes[obj : BilibiliVideoSectionObject[asc_?BilibiliVideoSectionObjectQ], form : (StandardForm | TraditionalForm)] := Module[
	{above, below},
	above = {
		{BoxForm`SummaryItem[{"Type: ", "VideoSection"}]},
		{BoxForm`SummaryItem[{"Section: ", asc["Me"]["name"]}]},
		{BoxForm`SummaryItem[{"Link: ", Hyperlink[StringSplit[#["url"], {"/", "."}][[-2]], #["url"]]&[asc["Me"]]}]}
	};
	below = {
		{BoxForm`SummaryItem[{"Count: ", asc["Count"]}]},
		{BoxForm`SummaryItem[{"Parent: ", Hyperlink[#["name"], #["url"]]&[asc["Parent"]]}]},
		{BoxForm`SummaryItem[{"Date: ", DateString[asc["Date"]]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",
		obj,
		$BilibiliLinkIcons["BilibiliVideoSectionObject"],
		above,
		below,
		form,
		"Interpretable" -> Automatic]
];
SetAttributes[
	{BilibiliVideoSectionObject},
	{Protected, ReadProtected}
];
End[];
