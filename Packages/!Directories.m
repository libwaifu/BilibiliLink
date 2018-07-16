$BilibiliLinkDirectory::usage = "BilibiliLink 的安装路径.";
$BilibiliLinkIcons::usage = "BilibiliLink 的图标映射.";
$BilibiliLinkData::usage = "BilibiliLink 的数据存放位置.";
BilibiliLink`§Directories::usage = "";
BilibiliLink`§Directories[___] := "";
Begin["`Directories`"];


$BilibiliLinkDirectory = DirectoryName[FindFile["BilibiliLink`Kernel`"], 2];
$BilibiliLinkData = FileNameJoin[{$UserBaseDirectory, "ApplicationData", "BilibiliLink"}];



$BLID::usage = "BilibiliLinkIconsDirectory,BilibiliLink 图片图标的存放路径.";
$BLID = FileNameJoin[{$BilibiliLinkDirectory, "Resources", "ico"}];
$BilibiliLinkIcons[name_] := $BilibiliLinkIcons[name] = Switch[name,
	"BilibiliAlbumObject",
	Image[Import[FileNameJoin[{$BLID, "BilibiliAlbumObject.jpg"}], "jpg"], ImageSize -> {Automatic, 140}],
	"BilibiliVideoSectionObject",
	Image[Import[FileNameJoin[{$BLID, "BilibiliVideoSectionObject.png"}], "png"], ImageSize -> {Automatic, 53}],
	"BilibiliDownloadObject",
	Image[Import[FileNameJoin[{$BLID, "BilibiliDownloadObject.png"}], "png"], ImageSize -> {Automatic, 64}]
];


SetAttributes[
	{$BLID},
	{Protected, ReadProtected}
];
End[];
