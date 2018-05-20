BilibiliAlumnObject::ussage="内部函数, 图片地址对象.";
Begin["`Object`"];
(* ::Subsection::Closed:: *)
(*BilibiliAlumnObjectPbject*)
BilibiliAlumnObjectQ::ussage="BilibiliAlumnObject 合法性检测";
BilibiliAlumnObjectQ[asc_?AssociationQ]:=AllTrue[{"Date"},KeyExistsQ[asc,#]&]
BilibiliAlumnObjectQ[_]=False;
(*
get=URLExecute["https://api.vc.bilibili.com/link_draw/v2/Doc/home","RawJSON"]["data"];
data=<|
	"DataType"->"AlumnIndexPage",
	"Data"->MapIndexed[<|"ID"->First@#2,"URL"->#1,"Name"->"画友主页_"<>ToString[First@#2]|>&,"img_src"/.get["items"]]
|>
BilibiliAlumnObjectExample=<|
	"Data"->data,
	"Category"->"Alumn Index Page",
	"Repo"->Length[data["Data"]],
	"Count"->Length[data["Data"]],
	"Size"->60855,
	"Time"->Quantity[1,"s"],
	"Date"->Now
|>;
*)
Format[BilibiliAlumnObject[___],OutputForm]:="BilibiliLink[>_<]~~";
Format[BilibiliAlumnObject[___],InputForm]:="BilibiliLink[>_<]~~";
BilibiliAlumnObject/:MakeBoxes[obj:BilibiliAlumnObject[asc_?BilibiliAlumnObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
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
		$BilibiliLinkIcons["BilibiliAlumnObject"],
		above,below,form,
		"Interpretable"->Automatic]
];


(*Aid Functions*)
SizeConvert[x_]:=N@Piecewise[{
	{Quantity[x, "Kilobytes"],x<1024/2},
	{Quantity[x/1024,"Megabytes"],1024^2/2>x>=1024/2},
	{Quantity[x/1024^2,"Gigabytes"],x>=1024^2/2}
}];






(*Interface*)
BilibiliAlumnObject[ass_][func_String]:=Switch[
	func,
	"Data",Lookup[ass,"Data"],
	"Image",Flatten["imgs"/.Lookup[ass,"Data"]];
	"Markdown",PicturePack2MD[ass],
	_,BilibiliPicturePackHelp[]
];
BilibiliAlumnObject[ass_][func_String,{para__}]:=Switch[
	func,
	_,BilibiliPicturePackHelp[]
];
BilibiliAlumnObject[ass_][___]:=BilibiliPicturePackHelp[];


(*Method*)













End[]