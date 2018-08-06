TagURL::usage = "";
TagGet::usage = "";
TagRange::usage = "";
TagRangeExport::usage = "";
CrawlerVideoTag::usage = "";
BilibiliLink`ㄑTag::usage = "";
BilibiliLink`ㄑTag[___] := "";
Begin["`Tag`"];


TagURL[tid_] := HTTPRequest[
	"https://api.bilibili.com/x/tag/info?tag_id=" <> ToString[tid],
	TimeConstraint -> 5
];
TagGetQ[get_] := Or[FailureQ@get, get["code"] != 0];
TagFormat[asc_] := <|
	"ID" -> asc["tag_id"],
	"Name" -> asc["tag_name"],
	If[KeyExistsQ[asc, "ctime"], "Date" -> FromUnixTime[asc["ctime"]], Nothing],
	"Count" -> asc["count", "use"],
	"Watch" -> asc["count", "atten"],
	If[KeyExistsQ[asc, "content"], "Detail" -> asc["content"], Nothing]
|>;
TagGet[i_, t_ /; t <= 0] := AppendTo[i, $fail];
TagGet[i_, try_] := Block[
	{get = URLExecute[TagURL@i, "RawJSON"]},
	If[TagGetQ[get],
		AppendTo[$block, Inactive[TagGet][i, try - 1]];
		Return[Nothing]
	];
	TagFormat[get["data"]]
];
VideoTagInfo[tid_] := TagFormat@URLExecute[TagURL@tid, "RawJSON"];
TagRange[a_, b_] := Block[
	{$fail = {}, $this = {}, $now = Now, $block, $query},
	$block = Table[Inactive[TagGet][i, 3], {i, a, b}];
	While[Length[$block] > 0,
		{$query, $block} = {RandomSample[$block], {}};
		$this = Join[$this, Activate[$query]]
	];
	<|
		"Now" -> $now,
		"Data" -> $this,
		"Failed" -> $fail,
		"Time" -> Now - $now
	|>
];
Options[TagRangeExport] = {Format -> "WXF", Path -> FileNameJoin[{$BilibiliLinkData, "Tag", "VideoTagInfo"}]};
TagRangeExport[a_, b_, OptionsPattern[]] := Block[
	{name = StringRiffle[{"Tag_", a, "-", b, "." <> OptionValue[Format]}, ""]},
	If[FileExistsQ@FileNameJoin[{OptionValue[Path], name}], Return[name]];
	CreateFile@FileNameJoin[{OptionValue[Path], name <> ".temp"}];
	Export[FileNameJoin[{OptionValue[Path], name}], TagRange[a, b], PerformanceGoal -> "Size"]
];
CrawlerVideoTag[max_Integer : 800 * 10^4, OptionsPattern[
	{"BatchSize" -> 1000, Path -> FileNameJoin[{$BilibiliLinkData, "Tag", "VideoTagInfo"}], Format -> "WXF"}
]] := Block[
	{retry = 0, finish = 0, expt, $blocks, $task},
	expt = TagRangeExport[#, # + OptionValue["BatchSize"] - 1, Path -> OptionValue[Path], Format -> "WXF"]&;
	AbortableMap[expt, Range[ 1, max, OptionValue["BatchSize"]]]
];
SetAttributes[
	{},
	{Protected, ReadProtected}
];
End[]
