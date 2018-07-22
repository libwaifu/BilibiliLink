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
End[] (* `Private` *)

EndPackage[]
