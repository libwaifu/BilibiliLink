BilibiliVipEmoji::usage="xxx";
BilibiliIndexIcon::usage="xxx";
BilibiliErrorPage::usage="xxx";
Begin["`DDOS`"];
VipEmojiReshape[line_]:=Block[
	{drop=KeyDrop[line["emojis"],{"state","remark"}]},
	Append[
		<|"ID"->#["id"],"URL"->#["url"],"Name"->StringTake[#["name"],2;;-2]|>&/@drop,
		<|"ID"->line["pid"],"URL"->line["purl"],"Name"->line["pname"]|>
	]];
BilibiliVipEmoji[]:=Block[
	{get=URLExecute["http://api.bilibili.com/x/v2/reply/emojis","RawJSON"]["data"]},
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Vip Emoji",
		"Data"->SortBy[Flatten[VipEmojiReshape/@get],"ID"],
		"Path"->File@FileNameJoin[{$BilibiliLinkData,"Image","Emoji"}],
		"Size"->UnitConvert[Quantity[5021696., "Bytes"], "Megabytes"]
	|>
]];
BilibiliVipEmoji["Raw"]:=URLExecute["http://api.bilibili.com/x/v2/reply/emojis","RawJSON"]["data"];



IndexIconReshape[line_]:=<|
	"ID"->line["id"],
	"Name"->line["title"],
	"URL"->line["icon"]
|>;
BilibiliIndexIcon[]:=Block[
	{get=URLExecute["https://www.bilibili.com/index/index-icon.json","RawJSON"]["fix"]},
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Index Icon",
		"Data"->SortBy[Flatten[IndexIconReshape/@get],"ID"],
		"Path"->File@FileNameJoin[{$BilibiliLinkData,"Image","Icon"}],
		"Size"->UnitConvert[Quantity[8015872., "Bytes"], "Megabytes"]
	|>
]];
BilibiliIndexIcon["Raw"]:=URLExecute["https://www.bilibili.com/index/index-icon.json","RawJSON"]["fix"];



ErrorPageExtension={
	"https://static.hdslb.com/error/400.png",
	"https://static.hdslb.com/error/403.png",
	"https://static.hdslb.com/error/404.png",
	"https://static.hdslb.com/error/444.png",
	"https://static.hdslb.com/error/500.png",
	"https://static.hdslb.com/error/502.png",
	"https://static.hdslb.com/error/503.png",
	"https://static.hdslb.com/error/504.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-1.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-2.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-3.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-4.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-5.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-6.png",
	"https://activity.hdslb.com/zzjs/cartoon/errorPage-manga-7.png",
	"https://static.hdslb.com/images/error/no_video_login.png",
	"https://static.hdslb.com/images/error/wait_for_review.png",
	"https://static.hdslb.com/images/error/wait_for_release.png",
	"https://static.hdslb.com/images/error/no_video.png",
	"https://static.hdslb.com/images/error/video_conflict.png"
};
ErrorPageExtensionReshape[url_,{id_}]:=<|
	"ID"->id,
	"Name"->StringSplit[url,{"/","."}][[-2]],
	"URL"->url
|>;
ErrorPageReshape[line_]:=<|
	"ID"->line["id"],
	"Name"->StringJoin["error_cover_",line["id"]],
	"URL"->line["data","img"]
|>;
BilibiliErrorPage[]:=Block[
	{get=URLExecute["www.bilibili.com/activity/web/view/data/31","RawJSON"]["data","list"],data},
	data=Join[ErrorPageReshape/@get,MapIndexed[ErrorPageExtensionReshape,ErrorPageExtension]];
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Error Page",
		"Data"->SortBy[data,"ID"],
		"Path"->File@FileNameJoin[{$BilibiliLinkData,"Image","ErrorPage"}],
		"Size"->UnitConvert[Quantity[58363904., "Bytes"], "Megabytes"]
	|>
]];



End[]