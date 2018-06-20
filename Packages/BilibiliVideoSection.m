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
End[];