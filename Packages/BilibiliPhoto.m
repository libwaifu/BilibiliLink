

BilibiliAlbumIndex::ussage="";

Begin["`Photo`"];
BilibiliAlbumIndex[]:=Module[{$now=Now,get,data},
	get=URLExecute["https://api.vc.bilibili.com/link_draw/v2/Doc/home","RawJSON"]["data"];
	data=<|
		"DataType"->"AlbumIndexPage",
		"Data"->MapIndexed[<|"Name"->StringJoin[ToString/@{UnixTime@Now,_,First@#2}],"URL"->#1|>&,"img_src"/.get["items"]]
	|>;
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"Album Index Page",
		"Repo"->Length[get["items"]]+1,
		"Count"->Length[get["items"]]+1,
		"Size"->Total@Select["img_size"/.get["items"],IntegerQ],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];
End[]