TagURL::usage = "";
TagGet::usage = "";
TagRange::usage = "";
TagRangeExport::usage = "";
CrawlerVideoTag::usage = "";
BilibiliLink`ㄑTag::usage = "";
BilibiliLink`ㄑTag[___] := "";
Begin["`Tag`"];


TagURL[tid_] := HTTPRequest[
	"http://api.bilibili.com/tags/info_description?id=" <> ToString[tid],
	TimeConstraint -> 5
];
TagGetQ[get_] := Or[FailureQ@get, get["code"] != 0];
TagFormat[asc_] := <|
	"ID" -> asc["tag_id"],
	"Name" -> asc["name"],
	"Count" -> asc["visit_count"],
	"Watch" -> asc["subscribe_count"]
|>;
TagGet[i_, t_ /; t <= 0] := AppendTo[i, $fail];
TagGet[i_, try_] := Block[
	{get = URLExecute[TagURL@i, "RawJSON"]},
	If[TagGetQ[get],
		AppendTo[$block, Inactive[TagGet][i, try - 1]];
		retry++; Return[Nothing]
	];
	finish++;
	TagFormat[get["result"]]
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
	Export[FileNameJoin[{OptionValue[dir], name}], TagRange[a, b], PerformanceGoal -> "Size"]
];
Options[CrawlerVideoTag] = {"BatchSize" -> 1000, Path -> FileNameJoin[{$BilibiliLinkData, "Tag", "VideoTagInfo"}]};
CrawlerVideoTag[max_ : 800 * 10^4, OptionsPattern[]] := Block[
	{retry = 0, finish = 0, expt, $blocks, $task},
	expt = Inactive[TagRangeExport][#, # + OptionValue["BatchSize"] - 1, OptionValue[Path]]&;
	$blocks = Table[expt[i], {i, 1, max, OptionValue["BatchSize"]}];
	$task = ParallelSubmit[Activate[#]]& /@ $blocks;
	Monitor[WaitAll[$task], {finish, retry}]
];

SetAttributes[
	{},
	{Protected, ReadProtected}
];
End[]
