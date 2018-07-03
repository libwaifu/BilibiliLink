VideoSectionQ::usage = "";
VideoSection::usage = "";
VideoIDIterate::usage = "遍历所有ID";
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




Options[DownloadByIDs] = {
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoData", "temp"}],
	"Overwrite" -> False,
	"Format" -> "WXF",
	"LimitTime" -> 10
};
DownloadByIDs[ps_, OptionsPattern[]] := Block[
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
Options[VideoIDIterate] = {
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoData",
		DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}]}
	],
	"LimitTime" -> 10,
	"Overwrite" -> False,
	"Format" -> "WXF",
	"BlockSize" -> 10000,
	"Min" -> 1,
	"Max" -> Automatic
};
VideoIDIterate[OptionsPattern[]] := Block[
	{min, max, do, r, fail},
	min = OptionValue["Min"];
	max = If[OptionValue["Max"] === Automatic, VideoMaxID[], OptionValue["Max"]];
	If[!FileExistsQ@OptionValue["Path"], CreateDirectory[OptionValue["Path"]]];
	do = DownloadByIDs[#,
		"Path" -> OptionValue["Path"],
		"Overwrite" -> OptionValue["Overwrite"],
		"Format" -> OptionValue["Format"],
		"LimitTime" -> OptionValue["LimitTime"]
	]&;
	r = Range[Ceiling[min / 100], Ceiling[max / 100]];
	fail = ParallelMap[do, Partition[r, UpTo[Ceiling[OptionValue["BlockSize"] / 100]]]];
	Print[Text@Style["Failed Block:", Red]];
	Flatten[fail]
];


End[];