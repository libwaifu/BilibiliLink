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
Options[BilibiliVipEmoji]={Path->FileNameJoin[{$BilibiliLinkData,"Image","Emoji"}]};
BilibiliVipEmoji[___,OptionsPattern[]]:=Block[
	{get=URLExecute["http://api.bilibili.com/x/v2/reply/emojis","RawJSON"]["data"]},
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Vip Emoji",
		"Data"->SortBy[Flatten[VipEmojiReshape/@get],"ID"],
		"Path"->OptionValue[Path],
		"Size"->5021696.
	|>
]];
BilibiliVipEmoji["Raw"]:=URLExecute["http://api.bilibili.com/x/v2/reply/emojis","RawJSON"]["data"];



IndexIconReshape[line_]:=<|
	"ID"->line["id"],
	"Name"->line["title"],
	"URL"->line["icon"]
|>;
Options[BilibiliIndexIcon]={Path->FileNameJoin[{$BilibiliLinkData,"Image","Icon"}]};
BilibiliIndexIcon[___,OptionsPattern[]]:=Block[
	{get=URLExecute["https://www.bilibili.com/index/index-icon.json","RawJSON"]["fix"]},
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Index Icon",
		"Data"->SortBy[Flatten[IndexIconReshape/@get],"ID"],
		"Path"->OptionValue[Path],
		"Size"->8015872.
	|>
]];
BilibiliIndexIcon["Raw"]:=URLExecute["https://www.bilibili.com/index/index-icon.json","RawJSON"]["fix"];
tsLine[doc_]:={
	"#### Title: "<>doc["id"]<>"_"<>doc["title"],
	"##### Time: "<>DateString[FromUnixTime[ToExpression@doc["sttime"]]],
	"##### Link: "<>StringDelete[URLDecode@URLDecode@First@doc["links"]," "],
	"!["<>First@doc["links"]<>"](https:"<>doc["icon"]<>")",
	"---"
};
BilibiliIndexIcon["Markdown",OptionsPattern[]]:=Block[
	{get=BilibiliIndexIcon["Raw"],file=OptionValue[Path],name},
	name=FileNameJoin[{file,"Readme.md"}];
	If[!FileExistsQ[file],CreateFile[file]];
	If[FileExistsQ[name],DeleteFile[name]];
	Export[name,StringJoin@Riffle[Flatten[tsLine/@SortBy[get,#["id"]&]],"\r"],"Text"]
]


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
Options[BilibiliErrorPage]={Path->FileNameJoin[{$BilibiliLinkData,"Image","Icon"}]};
BilibiliErrorPage[___,OptionsPattern[]]:=Block[
	{get=URLExecute["www.bilibili.com/activity/web/view/data/31","RawJSON"]["data","list"],data},
	data=Join[ErrorPageReshape/@get,MapIndexed[ErrorPageExtensionReshape,ErrorPageExtension]];
	BilibiliDownloadObject[<|
		"Date"->Now,
		"Category"->"Bilibili Error Page",
		"Data"->SortBy[data,"ID"],
		"Path"->OptionValue[Path],
		"Size"->58363904.
	|>
]];



End[]