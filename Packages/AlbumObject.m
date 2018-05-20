BilibiliPicturePackObject::ussage="内部函数, 图片地址对象.";
Begin["`Object`"];
(* ::Subsection::Closed:: *)
(*BilibiliPicturePackObjectPbject*)
BilibiliPicturePackObjectQ::ussage="BilibiliPicturePackObject 合法性检测";
BilibiliPicturePackObjectQ[asc_?AssociationQ] := AllTrue[{"Date","Count"}, KeyExistsQ[asc, #]&]
BilibiliPicturePackObjectQ[_] = False;
Format[BilibiliPicturePackObject[___],OutputForm]:="BilibiliLink[>_<]~~";
Format[BilibiliPicturePackObject[___],InputForm]:="BilibiliLink[>_<]~~";
BilibiliPicturePackObject/:MakeBoxes[obj:BilibiliPicturePackObject[asc_?BilibiliPicturePackObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"Type: ", "PicturesPack"}]},
		{BoxForm`SummaryItem[{"Category: ", asc["Category"]}]},
		{BoxForm`SummaryItem[{"Repo: ", asc["Repo"]}]},
		{BoxForm`SummaryItem[{"Count: ", asc["Count"]}]},
		{BoxForm`SummaryItem[{"Size: ", asc["Size"]}]},
		{BoxForm`SummaryItem[{"Time: ", asc["Time"]}]},
		{BoxForm`SummaryItem[{"Date: ", DateString[asc["Date"]]}]}
	};
	below = {};
	BoxForm`ArrangeSummaryBox[
		"BilibiliLink",
		obj,
		$BilibiliLinkIcons["BilibiliPicturePackObject"],
		above,
		below,
		form,
		"Interpretable" -> Automatic
	]
];



BilibiliPicturePackObject[ass_][func_String]:=Switch[
	func,
	"Data",Lookup[ass,"Data"],
	"Image",Flatten["imgs"/.Lookup[ass,"Data"]];
	"Markdown",PicturePack2MD[ass],
	_,BilibiliPicturePackHelp[]
];
BilibiliPicturePackObject[ass_][func_String,{para__}]:=Switch[
	func,
	_,BilibiliPicturePackHelp[]
];
BilibiliPicturePackObject[ass_][___]:=BilibiliPicturePackHelp[];






End[]