$BilibiliLinkDirectory::ussage="BilibiliLink 的安装路径.";
$BilibiliLinkIcons::ussage="BilibiliLink 的图标映射.";
Begin["`Directories`"];


$BilibiliLinkDirectory=DirectoryName[FindFile["BilibiliLink`Kernel`"],2];




$BLID::ussage="BilibiliLinkIconsDirectory,BilibiliLink 图片图标的存放路径.";
$BLID=FileNameJoin[{$BilibiliLinkDirectory,"Resources","ico"}]
$BilibiliLinkIcons[name_]:=$BilibiliLinkIcons[name]=Switch[name,
	"PicturesPack",Import[FileNameJoin[{$BLID,"PicturesPack.jpg"}],"jpg"]

];


SetAttributes[
	{$BilibiliLinkDirectory,$BilibiliLinkIcons,$BLID},
	{Protected,ReadProtected}
];
End[];