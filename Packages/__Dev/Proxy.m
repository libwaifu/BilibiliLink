(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: Proxy *)
(* :Context: Proxy` *)
(* :Author: Aster *)
(* :Date: 2018-07-22 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Aster *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["Proxy`"]
(* Exported symbols added here with SymbolName::usage *)


TagURL[id_] := HTTPRequest[
	"http://api.bilibili.com/tags/info_description?id=" <> ToString[id],
	TimeConstraint -> 5
];


Begin["`Private`"]
TagFormat[asc_] := <|
	"ID" -> asc["tag_id"],
	"Name" -> asc["tag_name"],
	"Detail" -> asc["content"],
	"Date" -> FromUnixTime[asc["ctime"]],
	"Count" -> asc["count", "use"],
	"Watch" -> asc["count", "atten"]
|>;

TagDown[i_, try_] := Block[
	{get},
	If[try <= 0, AppendTo[i, failure]];
	get = URLExecute[HTTPRequest["http://api.bilibili.com/x/tag/info?tag_id=" <> ToString[i], TimeConstraint -> 5], "RawJSON"];
	If[
		Or[FailureQ@get, get["code"] != 0],
		AppendTo[$Tasks, Inactive[TagDown][i, try - 1]];
		retry++;Return[Nothing]
	];
	finish++;
	TagFormat[get["data"]]
];


GetMemberRequest[mid_] := HTTPRequest[
	"https://space.bilibili.com/ajax/member/GetInfo",
	<|
		"Method" -> "POST",
		"Headers" -> {
			"content-type" -> "application/x-www-form-urlencoded;charset=UTF-8",
			"user-agent" -> "Mozilla/5.0 (X11;Linux i686) AppleWebKit/534.24 (KHTML,like Gecko) Chrome/11.0.696.68 Safari/534.24",
			"Referer" -> "https://space.bilibili.com/" <> ToString[mid]
		},
		"Body" -> "mid=" <> ToString[mid] <> "&csrf="
	|>,
	TimeConstraint -> 10
];
GetReg[id_] := Quiet@Block[
	{get = URLExecute[GetMemberRequest[id], "RawJSON"]},
	DateString[FromUnixTime[get["data", "regtime"]], {"Year", "Month", "Day"}] -> id
]

End[] (* `Private` *)

EndPackage[]
