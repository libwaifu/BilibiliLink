VideoSectionQ::usage = "";
VideoSection::usage = "";
VideoIDsRange::usage = "遍历所有ID";
VideoIDsList::usage = "遍历指定ID";
VideoIDsPack::usage = "打包缓存";
Begin["`Video`"];
VideoSectionQ = MemberQ[$APIs["RidList"] // Keys // Rest, #]&;
VideoSection[id_Integer] := Module[
	{get = URLExecute[$APIs["VideoSection"][id], "RawJson"]},
	If[!VideoSectionQ[id], Echo[Text@"编号不存在!", "Warning: "];Return@$Failed];
	BilibiliVideoSectionObject[<|
		"Me" -> $APIs["RidList"][id],
		"Parent" -> $APIs["RidList"][$APIs["RidList"][id, "parent"]],
		"Count" -> get["data", "page", "count"],
		"Date" -> Now
	|>]
];




Options[DownloadIDsRange] = {
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoDataRaw"}],
	"Overwrite" -> False,
	"Format" -> "WXF",
	"LimitTime" -> 10
};
DownloadIDsRange[ps_, OptionsPattern[]] := Block[
	{file, do, data,fail},
	file = FileNameJoin[{OptionValue["Path"],
		StringRiffle[{100(First@ps - 1) + 1, 100Last[ps]}, "-"] <> "." <> OptionValue["Format"]}
	];
	If[
		OptionValue["Overwrite"],
		If[FileExistsQ@file, DeleteFile[file]],
		If[FileExistsQ@file, Return[Nothing]]
	];
	do = URLExecute[HTTPRequest["https://api.bilibili.com/x/article/archives?ids=" <>
		StringRiffle[Range[100(# - 1) + 1, 100#], ","], TimeConstraint -> OptionValue["LimitTime"]
	], "RawJson"]["data"]&;
	{data, fail} = Quiet@Reap@Flatten[List @@@ Map[Check[do[#], Sow[#]]&, ps]];
	Export[file, Flatten[data], PerformanceGoal -> "Size"];
	Return[fail]
];
VideoMaxID[] := Module[
	{get, case},
	get = URLExecute["http://www.jijidown.com/new/video", {"HTML", "XMLObject"}];
	case = Cases[get, XMLElement["img", {__, "src" -> u_, __}, __] :> u, Infinity];
	Max@StringCases[case, "av=" ~~ id__ ~~ "&url" :> ToExpression[id]]
];
Options[VideoIDsRange] = {
	"Path" -> Automatic,
	"LimitTime" -> 4,
	"Overwrite" -> False,
	"Format" -> "WXF",
	"BlockSize" -> 10000,
	"Min" -> 1
};
VideoIDsRange[max_Integer : 0, OptionsPattern[]] := Module[
	{m, path, do, r, funs, fail, log},
	m = If[max == 0, VideoMaxID[], max];
	path = If[OptionValue["Path"] === Automatic,
		FileNameJoin[{$BilibiliLinkData, "VideoData",
			DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}]
		}],
		OptionValue["Path"]
	];
	If[!FileExistsQ@path, CreateDirectory[path]];
	do = Inactive[DownloadIDsRange][#,
		"Path" -> path,
		"Overwrite" -> OptionValue["Overwrite"],
		"Format" -> OptionValue["Format"],
		"LimitTime" -> OptionValue["LimitTime"]
	]&;
	r = Range[Ceiling[OptionValue["Min"] / 100], Ceiling[m / 100]];
	funs = do /@ Partition[r, UpTo[Ceiling[OptionValue["BlockSize"] / 100]]];
	fail = AbortableMap[Activate, funs];
	log = FileNameJoin[{path, DateString[{"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}] <> ".log.m"}];
	Export[log, <|
		"Date" -> Now,
		"FailedIDs" -> Flatten[fail[[-2,All,2]]],
		"RetryFunction"->"BilibiliLink`Video`DownloadIDsRange[...]"
	|>]
];
DistributeDefinitions[VideoIDsRange];

Options[DownloadIDsList] = {
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoDataRaw"}],
	"Overwrite" -> False,
	"Format" -> "WXF",
	"LimitTime" -> 10
};
DownloadIDsList[ls_, OptionsPattern[]] := Block[
	{file, group, do, data, fail},
	file = FileNameJoin[{OptionValue["Path"], Hash[ls, "MD5", "HexString"] <> "." <> OptionValue["Format"]}];
	If[
		OptionValue["Overwrite"],
		If[FileExistsQ@file, DeleteFile[file]],
		If[FileExistsQ@file, Return[Nothing]]
	];
	group = Partition[ls, UpTo[100]];
	do = URLExecute[HTTPRequest["https://api.bilibili.com/x/article/archives?ids=" <>
		StringRiffle[#, ","], TimeConstraint -> OptionValue["LimitTime"]
	], "RawJson"]["data"]&;
	{data, fail} = Quiet@Reap@Flatten[List @@@ Map[Check[do[#], Sow[#]]&, group]];
	Export[file, Flatten[data], PerformanceGoal -> "Size"];
	Return[fail]
];
Options[VideoIDsList] = {
	"Path" -> Automatic,
	"LimitTime" -> 4,
	"Overwrite" -> False,
	"Format" -> "WXF",
	"BlockSize" -> 10000
};
VideoIDsList[ls_, OptionsPattern[]] := Block[
	{path, do, fail, funs, log},
	path = If[OptionValue["Path"] === Automatic,
		FileNameJoin[{$BilibiliLinkData, "VideoData",
			DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}]}
		],
		OptionValue["Path"]
	];
	If[!FileExistsQ@path, CreateDirectory[path]];
	do = Inactive[DownloadIDsList][#,
		"Path" -> path,
		"Overwrite" -> OptionValue["Overwrite"],
		"Format" -> OptionValue["Format"],
		"LimitTime" -> OptionValue["LimitTime"]
	]&;
	funs = do /@ Partition[ls, UpTo[Ceiling[OptionValue["BlockSize"] / 100]]];
	fail = AbortableMap[Activate, funs];
	log = FileNameJoin[{path, DateString[{"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}] <> ".log.m"}];
	Export[log, <|
		"Date" -> Now;
		"FailedIDs" -> Flatten[fail]
	|>]
];
DistributeDefinitions[VideoIDsList];




VideoIdsFormat[asc_] := <|
	"VideoID" -> asc["aid"],
	"Title" -> asc["title"],
	"Date" -> FromUnixTime[asc["pubdate"]],
	"Length" -> asc["duration"],
	"Pages" -> asc["videos"],
	"Region" -> asc["tid"],
	"CID" -> asc["cid"],
	"OwnerID" -> asc["owner", "mid"],
	"OwnerName" -> asc["owner", "name"],
	"View" -> asc["stat", "view"],
	"Favorite" -> asc["stat", "favorite"],
	"Coin" -> asc["stat", "coin"],
	"Share" -> asc["stat", "share"],
	"Like" -> asc["stat", "like"],
	"Dislike" -> asc["stat", "dislike"],
	"Comment" -> asc["stat", "reply"],
	"HighestRank" -> asc["stat", "his_rank"]
|>;

Options[VideoIDsPack] = {
	"Pack" -> 1000,
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoDataRaw"}]
};
VideoIDsPack[fs_List, {num_ : 0}, OptionsPattern[]] := Block[
	{data, file, fmt},
	file = FileNameJoin[{OptionValue["Path"],"Block_"<>ToString[num] <> ".WXF"}];
	If[FileExistsQ@file,Return[Nothing]];
	data = Select[Flatten[Import /@ fs], AssociationQ];
	fmt = SortBy[VideoIdsFormat /@ data, #["VideoID"]&] /. {Missing[__] :> ""};
	Export[file, Dataset@fmt, PerformanceGoal -> "Size"];
	Length@fmt
];
VideoIDsPack[dir_String,ops: OptionsPattern[]] := Block[
	{all},
	If[!DirectoryQ[OptionValue["Path"]],VideoIDsPack[{dir}]];
	If[!FileExistsQ[OptionValue["Path"]], CreateDirectory[OptionValue["Path"]]];
	all=SortBy[FileNames[{"*.WXF","*.Json"},dir],ToExpression[StringSplit[#,{"\\","-"}][[-2]]]&];
	MapIndexed[AbsoluteTiming@VideoIDsPack[#,ops]&,Partition[all,UpTo[OptionValue["Pack"]]]]
];



End[];