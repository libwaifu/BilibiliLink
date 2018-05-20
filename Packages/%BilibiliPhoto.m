



Begin["`Photo`"];
BilibiliAlumnIndex[]:=Module[{$now=Now,get,data},
	get=URLExecute["https://api.vc.bilibili.com/link_draw/v2/Doc/home","RawJSON"]["data"];
	data=<|
		"DataType"->"AlumnIndexPage",
		"Data"->MapIndexed[<|"ID"->First@#2,"URL"->#1,"Name"->"画友主页_"<>ToString[First@#2]|>&,"img_src"/.get["items"]]
	|>;
	BilibiliAlumnObject[<|
		"Data"->data,
		"Category"->"Alumn Index Page",
		"Repo"->Length[get["items"]]+1,
		"Count"->Length[get["items"]]+1,
		"Size"->Total@Select["img_size"/.get["items"],IntegerQ],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];
End[]