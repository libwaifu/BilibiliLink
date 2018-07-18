$BilibiliServer::usage = "远程数据服务器";
BilibiliLink`ㄑRemote::usage = "";
BilibiliLink`ㄑRemote[___] := "";
Needs["MongoLink`"];
Begin["`Remote`"];
$BilibiliServer = "https://m.vers.site";
$DatabaseServer = "mongodb://biliman:readonly@45.32.68.44:37017/bilispider";
DatabaseClient=MongoLink`MongoConnect[$DatabaseServer];
TracedMemberDB=MongoLink`MongoGetCollection[DatabaseClient,"bilispider","trace_member_info"];
TracedVideoDB=MongoLink`MongoGetCollection[DatabaseClient,"bilispider","trace_video_stat"];





GetTraceRemote[id_]:=Block[
	{cursor,data},
	cursor=MongoLink`MongoCollectionFind[
		TracedVideoDB,
		<|"aid"->id|>,
		<|"_id"->False,"aid"->False|>
	];
	data=MongoLink`MongoCursorToArray[cursor]
];



SetAttributes[
	{},
	{Protected, ReadProtected}
];
End[]
