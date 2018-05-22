


PhotosRange::usage="";
PhotosHot::usage="";
PhotosNew::usage="";
Begin["`Photo`"];
$PhotoKeyMap=<|
	1-><|"Name"->"插画","Alias"->"Illustration","Key"->"illustration","Url"->"https://h.bilibili.com/eden/draw_area#/illustration"|>,
	2-><|"Name"->"漫画","Alias"->"Comic","Key"->"comic","Url"->"https://h.bilibili.com/eden/draw_area#/comic"|>,
	3-><|"Name"->"其他画作","Alias"->"OtherDraw","Key"->"draw","Url"->"https://h.bilibili.com/eden/draw_area#/other"|>,
	4-><|"Name"->"全部画作","Alias"->"DrawAll","Key"->"alld","Url"->"https://h.bilibili.com/eden/draw_area#/all"|>,
	5-><|"Name"->"Cosplay","Alias"->"Cosplay","Key"->"cos","Url"->"https://h.bilibili.com/eden/picture_area#/cos"|>,
	6-><|"Name"->"其他摄影","Alias"->"OtherPhoto","Key"->"sifu","Url"->"https://h.bilibili.com/eden/picture_area#/sifu"|>,
	7-><|"Name"->"全部摄影","Alias"->"PhotoAll","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>,
	8-><|"Name"->"日榜","Alias"->"AllPhoto","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>,
	9-><|"Name"->"月榜","Alias"->"AllPhoto","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>,
	10-><|"Name"->"月榜","Alias"->"AllPhoto","Key"->"allp","Url"->"https://h.bilibili.com/eden/picture_area#/all"|>
|>;
$PhotosAPI=<|
	"Home"->"https://api.vc.bilibili.com/link_draw/v2/Doc/home",
	"Range"->StringTemplate["https://api.vc.bilibili.com/link_draw/v1/doc/detail?doc_id=`id`"],
	"Detail"->StringTemplate["https://api.vc.bilibili.com/link_draw/v1/doc/detail?doc_id=`id`"],
	"Author"->StringTemplate["https://api.vc.bilibili.com/link_draw/v1/doc/doc_list?uid=`id`&page_num=`page`&page_size=100"],
	"AuthorCount"->StringTemplate["https://api.vc.bilibili.com/link_draw/v1/doc/upload_count?uid=`id`"],
	"AuthorDetail"->StringTemplate["https://api.vc.bilibili.com/user_ex/v1/user/detail?user[]=info&user[]=level&room[]=live_status&room[]=room_link&feed[]=fans_count&feed[]=feed_count&feed[]=is_followed&uid=`id`"],
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



PhotosRangeReshape::usage="PhotosRange的数据清洗.";
PhotosRangeReshape[doc_Association]:=<|
	"uid"->doc["user","uid"],
	"author"->doc["user","name"],
	"did"->doc["item","doc_id"],
	"title"->If[doc["item","title"]!="",
		doc["item","title"],
		"无名_"<>ToString[doc["item","doc_id"]]
	],
	"time"->DateObject[doc["item","upload_time"]],
	"imgs"->("img_src"/.doc["item","pictures"]),
	"size"->If[KeyExistsQ[First@doc["item","pictures"],"img_size"],
		Total["img_size"/.doc["item","pictures"]],
		Missing
	]
|>;
Options[PhotosRange]={RawData->False};
PhotosRange[n_Integer,ops:OptionsPattern[]]:=PhotosRange[Range[n],ops];
PhotosRange[a_Integer,b_Integer,ops:OptionsPattern[]]:=PhotosRange[Range[a,b],ops];
PhotosRange[input_List,OptionsPattern[]]:=Module[
	{$now=Now,urls,raw,data,count,size},
	urls=Table[$PhotosAPI["Range"][<|"id"->i|>],{i,input}];
	raw=#["data"]&/@Select[ParallelMap[URLExecute[#,"RawJSON"]&,urls],#["code"]==0&];
	If[OptionValue[RawData],Return[raw]];
	data=PhotosRangeReshape/@raw;
	If[data=={},
		count=0;size=0,
		count=Length@Flatten["imgs"/.data];
		size=Total@DeleteCases["size"/.data,Missing]
	];
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"PhotosRange",
		"Repo"->ToString[Length@input]<>" of ???",
		"Count"->count,
		"Size"->size,
		"Time"->Now-$now,
		"Date"->$now
	|>]
];

PhotosIndex::usage="";
PhotosIndex[]:=Module[
	{$now=Now,get,bg,size,imgs},
	get=URLExecute[$PhotosAPI["Home"],"RawJSON"]["data"];
	bg=<|"Name"->ToString[Now//UnixTime]<>"_0","URL"->get["bg_img"]|>;
	size=Total@DeleteCases["img_size"/.get["items"],"img_size"];
	imgs=Prepend["img_src"/.get["items"],bg];
	BilibiliAlbumObject[<|
		"Data"->{<|
			"uid"->12076317,
			"author"->"BilibiliHomePage",
			"did"->0,
			"title"->"HomePage "<>DateString[$now],
			"time"->$now,
			"imgs"->imgs,
			"size"->size
		|>},
		"Category"->"PhotosHomePage",
		"Repo"->"0 of 0",
		"Count"->Length@imgs,
		"Size"->size,
		"Time"->Now-$now,
		"Date"->$now
	|>]
];


PhotosHotReshape::usage="内部函数, 用于数据清洗";
PhotosHotReshape[doc_Association]:=<|
	"uid"->doc["user","uid"],
	"author"->doc["user","name"],
	"did"->doc["item","doc_id"],
	"title"->doc["item","title"],
	"time"->FromUnixTime[doc["item","upload_time"]],
	"imgs"->("img_src"/.doc["item","pictures"]),
	"size"->If[
		KeyExistsQ[First@doc["item","pictures"],"img_size"],
		Total["img_size"/.doc["item","pictures"]],
		Missing
	]
|>;
Options[PhotosHot]={UpTo->100,RawData->False};
PhotosHot[typenum_,OptionsPattern[]]:=Module[
	{$now=Now,api,map,raw,data},
	api=$PhotosAPI["Hot"][$PhotoKeyMap[typenum]["Key"]];
	map=Table[api[<|"p"->i|>],{i,0,Quotient[Min[OptionValue[UpTo]-1,500],20]}];
	raw=Flatten[URLExecute[#,"RawJSON"]["data","items"]&/@map];
	If[OptionValue[RawData],Return[raw]];
	data=PhotosHotReshape/@raw;
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"PhotosHot"<>$PhotoKeyMap[typenum]["Alias"],
		"Repo"->ToString[OptionValue[UpTo]]<>" of 500",
		"Count"->Length@Flatten["imgs"/.data],
		"Size"->Total@DeleteCases["size"/.data,Missing],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];


PhotosNewFindMax::usage="找到某一图片分类的总数.";
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
PhotosNewReshape::usage="内部函数, 用于数据清洗";
PhotosNewReshape[doc_Association]:=<|
	"uid"->doc["user","uid"],
	"author"->doc["user","name"],
	"did"->doc["item","doc_id"],
	"title"->doc["item","title"],
	"time"->FromUnixTime[doc["item","upload_time"]],
	"imgs"->("img_src"/.doc["item","pictures"]),
	"size"->If[
		KeyExistsQ[First@doc["item","pictures"],"img_size"],
		Total["img_size"/.doc["item","pictures"]],
		Missing]
|>;


Options[PhotosNew]={UpTo->100,RawData->False,Count->False,All->False};
PhotosNew[typenum_,OptionsPattern[]]:=Module[
	{$now=Now,api,all,map,raw,data},
	api=$PhotosAPI["New"][$PhotoKeyMap[typenum]["Key"]];
	If[OptionValue[Count],
		all=ToString[PhotosNewFindMax[$PhotoKeyMap[typenum]["Key"]]],
		all="???"
	];
	If[OptionValue[All],
		all=ToString[PhotosNewFindMax[$PhotoKeyMap[typenum]["Key"]]];
		map=Table[api[<|"p"->i|>],{i,0,Quotient[all-1,20]}],
		map=Table[api[<|"p"->i|>],{i,0,Quotient[OptionValue[UpTo]-1,20]}]
	];
	raw=Flatten[URLExecute[#,"RawJSON"]["data","items"]&/@map];
	If[OptionValue[RawData],Return[raw]];
	data=PhotosNewReshape/@raw;
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"PhotosNew"<>$PhotoKeyMap[typenum]["Alias"],
		"Repo"->ToString[OptionValue[UpTo]]<>" of "<>all,
		"Count"->Length@Flatten["imgs"/.data],
		"Size"->Total@DeleteCases["size"/.data,Missing],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];

PhotosAuthorReshape::usage="内部函数, 用于数据清洗";
PhotosAuthorReshape[doc_Association]:=<|
	"uid"->doc["poster_uid"],
	"author"->doc["description"],
	"did"->doc["doc_id"],
	"title"->If[doc["title"]=="",doc["doc_id"],doc["title"]],
	"time"->FromUnixTime[doc["ctime"]],
	"imgs"->("img_src"/.doc["pictures"]),
	"size"->If[
		KeyExistsQ[First@doc["pictures"],"img_size"],
		Total["img_size"/.doc["pictures"]],
		Missing
	]
|>;
PhotosAuthor[id_]:=Module[
	{$now=Now,count,api,raw,data},
	count=URLExecute[$PhotosAPI["AuthorCount"][<|"id"->id|>],"RawJSON"]["data"];
	api=URLExecute[$PhotosAPI["Author"][<|"id"->id,"page"->#|>],"RawJSON"]["data","items"]&;
	raw=Flatten@Table[api[i],{i,0,Quotient[count["all_count"]-1,100]}];
	data=PhotosAuthorReshape/@raw;
	BilibiliAlbumObject[<|
		"Data"->data,
		"Category"->"PhotosAuthor "<>ToString[id],
		"Repo"->ToString[raw//Length]<>" of "<>ToString[count["all_count"]],
		"Count"->Length@Flatten["imgs"/.data],
		"Size"->Total@DeleteCases["size"/.data,Missing],
		"Time"->Now-$now,
		"Date"->$now
	|>]
];


End[]