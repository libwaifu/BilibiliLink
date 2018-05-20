

BilibiliAlbumIndex::ussage="";

Begin["`Photo`"];
BilibiliAlbumIndex[]:=Module[
	{$now=Now,get,bg,imgs,data},
	get=URLExecute["https://api.vc.bilibili.com/link_draw/v2/Doc/home","RawJSON"]["data"];
	bg=<|"Name"->ToString[Now//UnixTime]<>"_0","URL"->get["bg_img"]|>;
	imgs=MapIndexed[<|"Name"->StringJoin[ToString/@{UnixTime@Now,_,First@#2}],"URL"->#1|>&,"img_src"/.get["items"]];
	data=<|
		"DataType"->"AlbumIndexPage",
		"ImageList"->Prepend[imgs,bg]
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