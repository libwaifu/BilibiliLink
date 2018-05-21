

BilibiliAlbumIndex::ussage="";

Begin["`Photo`"];
$PhotoCategoryMap=<|
	1-><|"Name"->"插画","Alias"->"Illustration","Key"->"illustration","Url"->"https://h.bilibili.com/eden/draw_area#/illustration"|>,
	2-><|"Name"->"漫画","Alias"->"Comic","Key"->"comic","Url"->"https://h.bilibili.com/eden/draw_area#/comic"|>,
	3-><|"Name"->"其他画作","Alias"->"OtherDraw","Key"->"draw","Url"->"https://h.bilibili.com/eden/draw_area#/other"|>,
	4-><|"Name"->"全部画作","Alias"->"AllDraw","Key"->"alld","Url"->"https://h.bilibili.com/eden/draw_area#/all"|>,
	5-><|"Name"->"Cosplay","Alias"->"Cosplay","Key"->"cos","Url"->"https://h.bilibili.com/eden/picture_area#/cos"|>,
	6-><|"Name"->"其他摄影","Alias"->"OtherPhoto","Key"->"sifu","Url"->"https://h.bilibili.com/eden/picture_area#/sifu"|>,
	7-><|"Name"->"全部摄影","Alias"->"AllPhoto","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>

|>;
$PhotosAPI=<|
	"Range"->StringTemplate["https://api.vc.bilibili.com/link_draw/v1/doc/detail?doc_id=`id`"],
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

PhotosRangeReshape::ussage="PhotosRange的数据清洗.";
PhotosRangeReshape[doc_Association]:=<|
	"uid"->doc["user","uid"],
	"author"->doc["user","name"],
	"did"->doc["item","doc_id"],
	"title"->If[doc["item","title"]!="",
		doc["item","title"],
		"无名_"<>ToString[doc["item","doc_id"]]
	],
	"time"->doc["item","upload_time"],
	"imgs"->("img_src"/.doc["item","pictures"]),
	"size"->If[KeyExistsQ[First@doc["item","pictures"],"img_size"],
		Total["img_size"/.doc["item","pictures"]],
		Missing
	]
|>;
Options[PhotosRange]={RawData->False};
PhotosRange[n_Integer,ops:OptionsPattern[]]:=PhotosRange[1,n,ops];
PhotosRange[a_Integer,b_Integer,OptionsPattern[]]:=Module[
	{$now=Now,urls,raw,data,count,size},
	urls=Table[$PhotosAPI["Range"][<|"id"->i|>],{i,a,b}];
	raw=#["data"]&/@Select[ParallelMap[URLExecute[#,"RawJSON"]&,urls],#["code"]==0&];
	If[OptionValue[RawData],Return[raw]];
	data=PhotosRangeReshape/@raw;
	If[data=={},
		count=0;size=0,
		count=Length@Flatten["imgs"/.data];
		size=Total@DeleteCases["size"/.data,Missing]
	];
	BilibiliAlbumObject[<|"Data"->data,
		"Category"->"PhotosRange",
		"Repo"->b-a+1,
		"Count"->count,
		"Size"->size,
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