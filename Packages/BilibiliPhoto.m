

BilibiliAlbumIndex::ussage="";

Begin["`Photo`"];
$PhotoCategoryMap=<|
	1-><|"Name"->"插画","Key"->"illustration","Url"->"https://h.bilibili.com/eden/draw_area#/illustration"|>,
	2-><|"Name"->"漫画","Key"->"comic","Url"->"https://h.bilibili.com/eden/draw_area#/comic"|>,
	3-><|"Name"->"其他画作","Key"->"draw","Url"->"https://h.bilibili.com/eden/draw_area#/other"|>,
	4-><|"Name"->"全部画作","Key"->"alld","Url"->"https://h.bilibili.com/eden/draw_area#/all"|>,
	5-><|"Name"->"Cosplay","Key"->"cos","Url"->"https://h.bilibili.com/eden/picture_area#/cos"|>,
	6-><|"Name"->"其他摄影","Key"->"sifu","Url"->"https://h.bilibili.com/eden/picture_area#/sifu"|>,
	7-><|"Name"->"全部摄影","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>

|>;
$PhotosAPI=<|
	"Home"->"https://api.vc.bilibili.com/link_draw/v2/Doc/home",
	"New"->Function[Switch[#,
		"illustration",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=illustration&type=new&page_num=`p`&page_size=20"],
		"comic",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=comic&type=new&page_num=`p`&page_size=20"],
		"draw",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=draw&type=new&page_num=`p`&page_size=20"],
		"alld",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=all&type=new&page_num=`p`&page_size=20"],
		"cos",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=cos&type=new&page_num=`p`&page_size=20"],
		"sifu",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=sifu&type=new&page_num=`p`&page_size=20"],
		"allp",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=all&type=new&page_num=`p`&page_size=20"]
	]],
	"Hot"->Function[Switch[#,
		"illustration",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=illustration&type=hot&page_num=`p`&page_size=20"],
		"comic",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=comic&type=hot&page_num=`p`&page_size=20"],
		"draw",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=draw&type=hot&page_num=`p`&page_size=20"],
		"alld",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=all&type=hot&page_num=`p`&page_size=20"],
		"cos",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=cos&type=hot&page_num=`p`&page_size=20"],
		"sifu",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=sifu&type=hot&page_num=`p`&page_size=20"],
		"allp",StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=all&type=hot&page_num=`p`&page_size=20"]
	]]
|>;

BilibiliAlbumIndex[]:=Module[
	{$now=Now,get,bg,imgs,data},
	get=URLExecute[$PhotosAPI["Home"],"RawJSON"]["data"];
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
SetAttributes[PhotosNewFindMax,Listable];
Options[PhotosNewFindMax]={Max->RandomInteger[{20000,21000}],Count->True};
PhotosNewFindMax[type_String,OptionsPattern[]]:=Module[
	{max,min,try,api},
	{min,max}={1,OptionValue[Max]};
	api=$PhotosAPI["New"][type];
	try=URLExecute[api[<|"p"->#|>],"RawJSON"]["data"]&;
	While[max-min>1,If[try[Floor[(min+max)/2]]["total_count"]>0,min=Floor[(min+max)/2],max=Floor[(min+max)/2]]];
	If[OptionValue[Count],Return[Length[try[min]["items"]]+20(min-1)],min]
];




End[]