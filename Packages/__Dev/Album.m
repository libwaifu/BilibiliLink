PhotosLeaderboard::usage = "h.bilibili.com 图片作品排行榜.";


BilibiliAlbumIndex::usage = "";
BilibiliAlbumIndex[] := Module[
	{$now = Now, get, bg, imgs, data},
	get = URLExecute[$PhotosAPI["Home"], "RawJSON"]["data"];
	bg = <|"Name" -> ToString[Now // UnixTime] <> "_0", "URL" -> get["bg_img"]|>;
	imgs = MapIndexed[<|"Name" -> StringJoin[ToString /@ {UnixTime@Now, _, First@#2}], "URL" -> #1|>&, "img_src" /. get["items"]];
	data = <|
		"DataType" -> "AlbumIndexPage",
		"ImageList" -> Prepend[imgs, bg]
	|>;
	BilibiliAlbumObject[<|
		"Data" -> data,
		"Category" -> "Album Index Page",
		"Repo" -> Length[get["items"]] + 1,
		"Count" -> Length[get["items"]] + 1,
		"Size" -> Total@Select["img_size" /. get["items"], IntegerQ],
		"Time" -> Now - $now,
		"Date" -> $now
	|>]
];





(* ::Subsection::Closed:: *)
(*PhotosLeaderboard*)
PictureDataRebuild::usage = "内部函数, 用于数据清洗";
PictureDataRebuild[doc_Association] := <|
	"uid" -> doc["user", "uid"],
	"author" -> doc["user", "name"],
	"did" -> doc["item", "doc_id"],
	"title" -> doc["item", "title"],
	"time" -> FromUnixTime[doc["item", "upload_time"]],
	"imgs" -> ("img_src" /. doc["item", "pictures"]),
	"size" -> If[KeyExistsQ[First@doc["item", "pictures"], "img_size"],
		Quantity[Total["img_size" /. doc["item", "pictures"]] / 1024.0, "Megabytes"],
		Missing
	]
|>;
$PhotoMap = <|"Cosplay" -> "cos", "其他服饰" -> "sifu", "插画" -> "illustration", "漫画" -> "comic", "其他画作" -> "draw", "全部画作" -> "all"|>;
PhotosLeaderboard[cat_] := Module[
	{$now = Now, map, raw, data},
	map = Switch[cat,
		"Cosplay", $APIs["PhotoHot"]["cos"],
		"其他服饰", $APIs["PhotoHot"]["sifu"],
		"插画作品", $APIs["PhotoHot"]["illustration"],
		"漫画作品", $APIs["PhotoHot"]["comic"],
		"其他画作", $APIs["PhotoHot"]["draw"],
		"全部画作", $APIs["PhotoHot"]["all"],
		"日榜", $APIs["PhotoRank"]["day"],
		"周榜", $APIs["PhotoRank"]["week"],
		"月榜", $APIs["PhotoRank"]["month"],
		_, Echo[Text@"可选参数:Cosplay,其他服饰,插画作品,漫画作品,其他画作,全部画作,日榜,周榜,月榜"];Return[$Failed]
	];
	raw = URLExecute[HTTPRequest[#, TimeConstraint -> 10], "RawJSON"]["data", "items"]& /@ map;
	data = PictureDataRebuild /@ Flatten[raw];
	BilibiliPicturePackObject[<|
		"Data" -> data,
		"Category" -> Text@cat,
		"Repo" -> Length@data,
		"Count" -> Length@Flatten["imgs" /. data],
		"Size" -> Total@DeleteCases["size" /. data, Missing],
		"Time" -> Now - $now,
		"Date" -> $now
	|>]
];

AlbumDownload[raw_] := Switch[
	raw["Data", "DataType"],
	"AlbumIndexPage", AlbumIndexPageDownload[raw]



];


Options[AlbumIndexPageDownload] = {ImageSize -> Full, Defer -> False};
AlbumIndexPageDownload[ass_, OptionsPattern[]] := Block[
	{size = OptionValue[ImageSize], obj, resize},
	resize = <|"Name" -> #["Name"] <> ToString[size], "URL" -> #["URL"] <> ImageSizeConvert[size]|>&;
	obj = BilibiliDownloadObject[<|
		"Date" -> ass["Date"],
		"Category" -> ass["Data", "DataType"],
		"Data" -> (resize /@ ass["Data", "ImageList"]),
		"Path" -> FileNameJoin[{$BilibiliLinkData, "Image", "Album", "Index"}],
		"Size" -> Quantity[ass["Size"] / 1024., "Megabytes"]
	|>];
	If[OptionValue[Defer], Return[obj], obj["Download"]]
];
