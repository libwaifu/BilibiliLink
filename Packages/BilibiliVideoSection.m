VideoSectionQ::usage = "";
VideoSection::usage = "";
VideoIDsRange::usage = "遍历所有ID";
VideoIDsPack
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
	{file, do, data, fail},
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
	"LimitTime" -> 10,
	"Overwrite" -> False,
	"Format" -> "WXF",
	"BlockSize" -> 10000,
	"Min" -> 1
};
VideoIDsRange[max_Integer : 0, OptionsPattern[]] := Block[
	{m, path, do, r, fail},
	m = If[max == 0, VideoMaxID[], max];
	path = If[OptionValue["Path"] === Automatic,
		FileNameJoin[{$BilibiliLinkData, "VideoData",
			DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}]}
		],
		OptionValue["Path"]
	];
	If[!FileExistsQ@path, CreateDirectory[path]];
	do = Evaluate@Function[DownloadIDsRange[#,
		"Path" -> OptionValue["Path"],
		"Overwrite" -> OptionValue["Overwrite"],
		"Format" -> OptionValue["Format"],
		"LimitTime" -> OptionValue["LimitTime"]
	]];
	r = Range[Ceiling[OptionValue["Min"] / 100], Ceiling[m / 100]];
	(*Return@{OptionValue["Min"],OptionValue["Path"],OptionValue["BlockSize"],max,m};*)
	fail = AbortableMap[do, Partition[r, UpTo[Ceiling[OptionValue["BlockSize"] / 100]]]];
	Export[FileNameJoin[{path,
		DateString[{"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}    ]
			<> ".log.m"}], fail];
	Flatten[fail]
];
DistributeDefinitions[VideoIDsRange];

VideoIdsFormat[asc_] := <|
	"VideoID" -> asc["aid"],
	"Title" -> asc["title"],
	"Date" -> asc["pubdate"],
	"Length" -> asc["duration"],
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
	"Comment" -> asc["stat", "reply"]
|>;
Options[VideoIDsPack] = {
	"Pack" -> FileNameJoin[{$BilibiliLinkData, "VideoDataPack"}],
	"Raw" -> FileNameJoin[{$BilibiliLinkData, "VideoDataRaw"}],
	"Overwrite" -> False
};
Options[VideoIDsPack] = {"Path" -> "D:\\BilibiliVideoDataPack"};
VideoIDsPack[fs_, {num_ : 0}, OptionsPattern[]] := Block[
	{data, fmt},
	If[!FileExistsQ[OptionValue["Path"]], CreateDirectory[OptionValue["Path"]]];
	data = Select[Flatten[Import /@ fs], AssociationQ];
	fmt = SortBy[VideoIdsFormat /@ data, #["VideoID"]&];
	Export[FileNameJoin[{OptionValue["Path"], "Block_" <> ToString[num] <> ".WXF"}], fmt, PerformanceGoal -> "Size"]
];



End[];