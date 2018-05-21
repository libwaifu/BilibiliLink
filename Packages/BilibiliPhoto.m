

BilibiliAlbumIndex::ussage="";

Begin["`Photo`"];
$PhotosAPI=<|
	"New"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=`type`&type=new&page_num=`p`&page_size=20"]


|>;

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
PhotosNewFindMax::ussage="找到某一图片分类的总数.";
Options[PhotosNewFindMax]={Max->999,Count->True};
PhotosNewFindMax[type_,OptionsPattern[]]:=Module[
	{max,min,try},
	{min,max}={1,OptionValue[Max]};
	try=URLExecute[$PhotosAPI["New"][<|"type"->type,"p"->#|>],"RawJSON"]["data"]&;
	While[max-min>1,If[try[Floor[(min+max)/2]]["total_count"]>0,min=Floor[(min+max)/2],max=Floor[(min+max)/2]]];
	If[OptionValue[Count],Return[Length[try[min]["items"]]+20(min-1)],min]
];




End[]