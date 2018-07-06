AbortableMap::usage = "";
Begin["`Functions`"]
timeLeft[start_, frac_] := With[{past = AbsoluteTime[] - start}, If[frac == 0 || past < 1, "-", Floor[past / frac - past]]];
AbortableMap[func_, list_, ker_ : $KernelCount] := DynamicModule[
	{len, bag, size, lastresults, starttime, n, results, t},
	len = Length[list]; size = 0; starttime = AbsoluteTime[];
	results = {}; SetSharedVariable[results, size];
	Monitor[
		t = Table[ParallelSubmit[{i},
			With[
				{r = func[list[[i]]]},
				size += ByteCount[r];
				AppendTo[results, {i, r}]
			]
		], {i, Range[len]}];
		CheckAbort[WaitAll[t], AbortKernels[]];
		SortBy[results, First],
		Dynamic@Refresh[Panel @ Column[{
			ProgressIndicator[Length[results] / len, ImageSize -> 350],
			Row[{Button["Abort", Abort[]],
				Grid[{{"Tasks", "Memory (kB)", "Time left (s)"},
					{StringForm["``/``", Length[results], len],
						ToString @ NumberForm[size / 2.^10, {3, 2}],
						ToString @ timeLeft[starttime, Length[results] / len]}
				}, Spacings -> {1, 1}, ItemSize -> {10, 1}, Dividers -> Center
				]}, Spacer[5]]
		}], UpdateInterval -> 1, TrackedSymbols -> {}
		]
	]
];
WriteCSV[file_String, matrix_] := With[
	{
		str = OpenWrite[file, PageWidth -> Infinity],
		len = Length[First@matrix]
	},
	Scan[Write[str,
		Sequence @@ (Flatten[
			Table[{FortranForm[#[[i]]], OutputForm[","]}, {i, len - 1}]
		]) ~ Join ~ {FortranForm[#[[len]]]}]&, matrix
	];
	Close[str];
];
End[]