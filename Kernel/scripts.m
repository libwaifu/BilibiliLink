(* ::Package:: *)

BScript`Pack[]:=Module[
	{add,info,paclet},
	add[v_]:=Block[
		{p,sp=StringSplit[v,"."]},
		p=ToString[ToExpression[Last@sp]+1];
		StringRiffle[Append[Most@sp,p],"."]
	];
	info=FindFile["BilibiliLink/PacletInfo.m"];
	paclet=Import[info]/.{("Version"->v__)->("Version"->Inactive[add][v])}//Activate;
	Export[info,StringReplace[ToString[paclet,InputForm],
		{
			"["->"[\n","]"->"\n]",
			"{"->"{\n","}"->"\n}",
			","->",\n"
		}
	],"Text"];
	PacletInformation[PackPaclet["BilibiliLink"]]
];


(* ::CodeText:: *)
(*BScript`Pack[]*)
