VipEmoji::usage = "xxx";
IndexIcon::usage = "xxx";
ErrorPage::usage = "xxx";
HeaderBanner::usage = "xxx";
HeaderLogo::usage = "xxx";
BilibiliLink`§DDOS::usage = "";
BilibiliLink`§DDOS[___] := "";
Begin["`DDOS`"];
VipEmojiReshape[line_] := Block[
	{drop = KeyDrop[line["emojis"], {"state", "remark"}]},
	Append[
		<|"ID" -> #["id"], "URL" -> #["url"], "Name" -> StringTake[#["name"], 2 ;; -2]|>& /@ drop,
		<|"ID" -> line["pid"], "URL" -> line["purl"], "Name" -> line["pname"]|>
	]];
Options[VipEmoji] = {Path -> FileNameJoin[{$BilibiliLinkData, "Image", "Emoji"}]};
VipEmoji[___, OptionsPattern[]] := Block[
	{get = URLExecute["http://api.bilibili.com/x/v2/reply/emojis", "RawJSON"]["data"]},
	BilibiliDownloadObject[<|
		"Date" -> Now,
		"Category" -> "Bilibili Vip Emoji",
		"Data" -> SortBy[Flatten[VipEmojiReshape /@ get], "ID"],
		"Path" -> OptionValue[Path],
		"Size" -> 5021696.
	|>
	]];
VipEmoji["Raw"] := URLExecute["http://api.bilibili.com/x/v2/reply/emojis", "RawJSON"]["data"];



IndexIconReshape[line_] := <|
	"ID" -> line["id"],
	"Name" -> line["title"],
	"URL" -> line["icon"]
|>;
Options[IndexIcon] = {Path -> FileNameJoin[{$BilibiliLinkData, "Image", "Icon"}]};
IndexIcon[___, OptionsPattern[]] := Block[
	{get = URLExecute["https://www.bilibili.com/index/index-icon.json", "RawJSON"]["fix"]},
	BilibiliDownloadObject[<|
		"Date" -> Now,
		"Category" -> "Bilibili Index Icon",
		"Data" -> SortBy[Flatten[IndexIconReshape /@ get], "ID"],
		"Path" -> OptionValue[Path],
		"Size" -> 8015872.
	|>
	]];
IndexIcon["Raw"] := URLExecute["https://www.bilibili.com/index/index-icon.json", "RawJSON"]["fix"];
tsLine[doc_] := {
	"#### Title: " <> doc["id"] <> "_" <> doc["title"],
	"##### Date: " <> DateString[FromUnixTime[ToExpression@doc["sttime"]]],
	"##### Link: " <> StringDelete[URLDecode@URLDecode@First@doc["links"], " "],
	"![" <> First@doc["links"] <> "](https:" <> doc["icon"] <> ")",
	"---"
};
IndexIcon["Markdown", OptionsPattern[]] := Block[
	{get = IndexIcon["Raw"], file = OptionValue[Path], name},
	name = FileNameJoin[{file, "IndexIcon.md"}];
	If[!FileExistsQ[file], CreateFile[file]];
	If[FileExistsQ[name], DeleteFile[name]];
	Export[name, StringJoin@Riffle[Flatten[tsLine /@ SortBy[get, ToExpression[#["id"]]&]], "\r"], "Text"]
];


$ErrorPageExtension = {
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
ErrorPageExtensionReshape[url_, {id_}] := <|
	"ID" -> id,
	"Name" -> StringSplit[url, {"/", "."}][[-2]],
	"URL" -> url
|>;
ErrorPageReshape[line_] := <|
	"ID" -> line["id"],
	"Name" -> StringJoin["error_cover_", line["id"]],
	"URL" -> line["data", "img"]
|>;
Options[ErrorPage] = {Path -> FileNameJoin[{$BilibiliLinkData, "Image", "Icon"}]};
ErrorPage[___, OptionsPattern[]] := Block[
	{get = URLExecute["www.bilibili.com/activity/web/view/data/31", "RawJSON"]["data", "list"], data},
	data = Join[ErrorPageReshape /@ get, MapIndexed[ErrorPageExtensionReshape, $ErrorPageExtension]];
	BilibiliDownloadObject[<|
		"Date" -> Now,
		"Category" -> "Bilibili Error Page",
		"Data" -> SortBy[data, "ID"],
		"Path" -> OptionValue[Path],
		"Size" -> 58363904.
	|>]
];


HeaderReshape[asc_] := Module[
	{name, banner, icon, c = asc["c"]},
	If[c === {}, Return[Nothing]];
	name = If[KeyExistsQ[asc["c"], "title"], c["title"], c["name"]];
	icon = If[
		KeyExistsQ[asc["c"], "logo"],
		Last@StringSplit[c["logo"], "/"],
		Last@StringSplit[c["litpic"], "/"]
	];
	banner = If[
		KeyExistsQ[asc["c"], "pic"],
		Last@StringSplit[c["pic"], "/"],
		Last@StringSplit[c["background"], "/"]
	];
	<|
		"Title" -> c["name"],
		"Date" -> First@StringSplit[asc["n"], {"_", "-"}],
		"Banner" -> "https://i0.hdslb.com/headers/" <> banner,
		"Logo" -> "https://i0.hdslb.com/headers/" <> icon,
		"Link" -> c["url"]
	|>
];
GetHeader[] := GetHeader[] = Block[
	{get, json, list},
	get = URLFetch["https://www.biliplus.com/task/banner_fetch/"];
	json = First@StringCases[get, "var items=" ~~ json__ ~~ "}}];" :> json <> "}}]"];
	list = ImportString[ToString[json, CharacterEncoding -> "UTF8"], "RawJSON"];
	HeaderReshape /@ list
];

HeaderBannerReshape[line_, {index_}] := <|"ID" -> index, "Name" -> StringSplit[line["Banner"], {"/", "."}][[-2]], "URL" -> line["Banner"]|>;
Options[HeaderBanner] = {Path -> FileNameJoin[{$BilibiliLinkData, "Image", "Banner"}]};
HeaderBanner[___, OptionsPattern[]] := Block[
	{get = GetHeader[], data},
	data = MapIndexed[HeaderBannerReshape, get];
	BilibiliDownloadObject[<|
		"Date" -> Now,
		"Category" -> "Bilibili Header Banner",
		"Data" -> SortBy[data, "ID"],
		"Path" -> OptionValue[Path],
		"Size" -> 118206806.
	|>]
];
HeaderLogoReshape[line_, {index_}] := <|"ID" -> index, "Name" -> StringSplit[line["Logo"], {"/", "."}][[-2]], "URL" -> line["Logo"]|>;
Options[HeaderLogo] = {Path -> FileNameJoin[{$BilibiliLinkData, "Image", "Logo"}]};
HeaderLogo[___, OptionsPattern[]] := Block[
	{get = GetHeader[], data},
	data = MapIndexed[HeaderLogoReshape, get];
	BilibiliDownloadObject[<|
		"Date" -> Now,
		"Category" -> "Bilibili Header Logo",
		"Data" -> SortBy[data, "ID"],
		"Path" -> OptionValue[Path],
		"Size" -> 17955498.
	|>]
];
End[]
