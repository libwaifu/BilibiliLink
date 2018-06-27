VideoSectionQ::usage = "";
VideoSection::usage = "";
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
	{file, urls, rq, data, fail},
	file = FileNameJoin[{OptionValue["Path"],
		StringRiffle[{100(First@ps - 1) + 1, 100Last[ps]}, "-"] <> "." <> OptionValue["Format"]}
	];
	rq = HTTPRequest["https://api.bilibili.com/x/article/archives?ids=" <>
		StringRiffle[Range[100(# - 1) + 1, 100#], ","], TimeConstraint -> OptionValue["LimitTime"]
	]&;
	fail = Quiet@Reap[Check[rq[#], Sow[#]]& /@ ps];
	If[
		OptionValue["Overwrite"],
		If[FileExistsQ@file, DeleteFile[file]],
		If[FileExistsQ@file, Return[Nothing]]
	];
	data = List @@@ Map[URLExecute[#, "RawJson"]["data"]&, urls];
	Export[file, Flatten[data], PerformanceGoal -> "Size"];
	Return[file]
];
VideoMaxID[] := Module[
	{get, case},
	get = URLExecute["http://www.jijidown.com/new/video", {"HTML", "XMLObject"}];
	case = Cases[get, XMLElement["img", {__, "src" -> u_, __}, __] :> u, Infinity];
	Max@StringCases[case, "av=" ~~ id__ ~~ "&url" :> ToExpression[id]]
];


End[];