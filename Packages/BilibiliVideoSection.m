(* ::Package:: *)
(* ::Title:: *)
(*Example(样板包)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template*)
(**)
(* ::Text:: *)
(*Author:我是作者*)
(*Creation Date:我是创建日期*)
(*Copyright: Mozilla Public License Version 2.0*)
(* ::Program:: *)
(*1.软件产品再发布时包含一份原始许可声明和版权声明。*)
(*2.提供快速的专利授权。*)
(*3.不得使用其原始商标。*)
(*4.如果修改了源代码，包含一份代码修改说明。*)
(**)
(* ::Section:: *)
(*函数说明*)
VideoSectionQ::usage = "";
VideoSection::usage = "";
VideoIDsRange::usage = "遍历所有ID";
VideoIDsList::usage = "遍历指定ID";
VideoIDsPack::usage = "打包缓存";
VideoIDsInsertDB::usage = "插入数据库";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
BilibiliLink`ㄑVideo::usage = "";
BilibiliLink`ㄑVideo[___] := "";
Begin["`Video`"];
(* ::Subsection:: *)
(*功能块 2*)
timeLeft[start_, frac_] := With[{past = AbsoluteTime[] - start}, If[frac == 0 || past < 1, "-", Floor[past / frac - past]]];
(* ::Subsection:: *)
(*功能块 2*)
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



(* ::Subsection:: *)
(*功能块 2*)
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
		"FailedIDs" -> Flatten[fail[[-2, All, 2]]],
		"RetryFunction" -> "BilibiliLink`Video`DownloadIDsRange[...]"
	|>]
];
DistributeDefinitions[VideoIDsRange];
(* ::Subsection:: *)
(*功能块 2*)
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



(* ::Subsection:: *)
(*功能块 2*)
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
(* ::Subsection:: *)
(*功能块 2*)
Options[VideoIDsPack] = {
	"Pack" -> 1000,
	"Path" -> FileNameJoin[{$BilibiliLinkData, "VideoDataRaw"}],
	"Format" -> "WXF"
};
VideoIDsPack[fs_List, {num_ : 0}, OptionsPattern[]] := Block[
	{data, file, fmt},
	file = FileNameJoin[{OptionValue["Path"], "Block_" <> ToString[num] <> ".WXF"}];
	If[FileExistsQ@file, Return[Nothing]];
	data = Select[Flatten[Import /@ fs], AssociationQ];
	fmt = SortBy[VideoIdsFormat /@ data, #["VideoID"]&] /. {Missing[__] :> ""};
	Export[file, Dataset@fmt, PerformanceGoal -> "Size"];
	Length@fmt
];
VideoIDsPack[dir_String, ops : OptionsPattern[]] := Block[
	{all},
	If[!DirectoryQ[OptionValue["Path"]], VideoIDsPack[{dir}]];
	If[!FileExistsQ[OptionValue["Path"]], CreateDirectory[OptionValue["Path"]]];
	all = SortBy[FileNames[{"*.WXF", "*.Json"}, dir], ToExpression[StringSplit[#, {"\\", "-"}][[-2]]]&];
	MapIndexed[AbsoluteTiming@VideoIDsPack[#, ops]&, Partition[all, UpTo[OptionValue["Pack"]]]]
];


(* ::Subsection:: *)
(*功能块 2*)
VideoIDsInsertPack[fs_, co_] := Block[
	{in = Select[Flatten[Import /@ fs], AssociationQ]},
	MongoLink`MongoCollectionInsert[co, Map[VideoIdsFormat, in] /. Missing[__] :> ""];
	Length[in]
] // AbsoluteTiming;
Options[VideoIDsInsertDB] = {"BatchSize" -> 1};
VideoIDsInsertDB[dir_String, db_, OptionsPattern[]] := Block[
	{client, all, pt, tasks, ans, i = 0, j = 0, now =Now},
	all = SortBy[FileNames[{"*.WXF", "*.Json"}, dir], ToExpression[StringSplit[#, {"\\", "-"}][[-2]]]&];
	pt = Partition[all, UpTo[OptionValue["BatchSize"]]];
	ans = With[
		{table = MongoLink`MongoGetCollection[db, StringJoin["VideoData_",
			DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}]
		]]},
		Monitor[Map[
			Reap[Check[i++;VideoIDsInsertPack[#, table], j++; Sow[#]]
			]& , pt],
			Grid[{
				{Text[Style["Transforming :", Darker@Blue]], ProgressIndicator[i, {0, Length[pt]}]},
				{
					Text[Style["Error Cases : ", Darker@Red]],
					StringJoin[ToString/@{j,"   --- Time Left: ",timeLeft[AbsoluteTime[now], (i+j )/ Length[pt]]}]
				}
			},
				Alignment -> Left,
				Dividers -> Center
			]
		]
	];
	Echo[Quantity[Total[ans[[All, 1, 2]]] / Total[ans[[All, 1, 1]]], "Kilobytes" / "Seconds"], "Speed: "];
	<|"Failed" -> Flatten[ans[[All, -1]]]|>
];

(* ::Subsection::Closed:: *)
(*附加设置*)
SetAttributes[
	{ },
	{Protected,ReadProtected}
];
End[]
