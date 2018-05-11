



$APIs="";
$RawAPIs="内部变量, Bilibili提供的API";

Begin["`APIs`"];


$RawAPIs=<|
	"archive"-><|
		"url"->StringTemplate["https://api.bilibili.com/x/web-interface/archive/stat?aid=`aid`"],
		"detail"->""
	|>,
	"arch"-><|
		"url"->StringTemplate["https://api.bilibili.com/archive_stat/stat?aid=`aid`"],
		"detail"->"效果和archive接口相同."
	|>,
	"cid"-><|
		"url"->StringTemplate["http://www.bilibilijj.com/Api/AvToCid/`aid`/0"],
		"detail"->"哔哩哔哩唧唧的cid查询端口, 本机必须使用apikeys或cookies才能得到."
	|>,
	"photohot"-><|
		"url"-><|
			"illustration"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=illustration&type=hot&page_num=`page`&page_size=20"],
			"comic"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=comic&type=hot&page_num=`page`&page_size=20"],
			"draw"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=draw&type=hot&page_num=`page`&page_size=20"],
			"all"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=all&type=hot&page_num=`page`&page_size=20"],
			"cos"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=cos&type=hot&page_num=`page`&page_size=20"],
			"sifu"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=sifu&type=hot&page_num=`page`&page_size=20"]
		|>,
		"detail"->"h.bilibili.com的热门作品."
	|>,
	"photorank"-><|
		"url"-><|
			"a"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=1&rank_type=`time`&page_size=50"],
			"b"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=2&category=cos&rank_type=`time`&page_size=50"],
			"c"->StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=2&category=sifu&rank_type=`time`&page_size=50"]
		|>,
		"detail"->"h.bilibili.com的热门作品."
	|>

|>;




(*https://github.com/Vespa314/bilibili-api/blob/master/api.md*)
$RidList=<|
	12-><|"father"->"未知","name"->"公告(隐藏)"|>,
	15-><|"father"->"电视剧","name"->"连载剧集(隐藏)"|>,
	16-><|"father"->"游戏","name"->"flash游戏(隐藏)"|>,
	17-><|"father"->"游戏","name"->"单机联机"|>,
	19-><|"father"->"游戏","name"->"Mugen"|>,
	20-><|"father"->"舞蹈","name"->"宅舞"|>,
	21-><|"father"->"生活","name"->"日常"|>,
	22-><|"father"->"鬼畜","name"->"鬼畜调教"|>,
	24-><|"father"->"动画","name"->"MAD/AMV"|>,
	25-><|"father"->"动画","name"->"MMD/3D"|>,
	26-><|"father"->"鬼畜","name"->"音MAD"|>,
	27-><|"father"->"动画","name"->"综合"|>,
	28-><|"father"->"音乐","name"->"原创音乐"|>,
	29-><|"father"->"音乐","name"->"三次元音乐"|>,
	30-><|"father"->"音乐","name"->"VOCALOID/UTAU"|>,
	31-><|"father"->"音乐","name"->"翻唱"|>,
	32-><|"father"->"番剧","name"->"完结动画"|>,
	33-><|"father"->"番剧","name"->"连载动画"|>,
	37-><|"father"->"纪录片","name"->"人文历史"|>,
	39-><|"father"->"科技","name"->"演讲/ 公开课"|>,
	41-><|"father"->"未知","name"->"未知(隐藏)"|>,
	46-><|"father"->"动画","name"->"MMD.3D(隐藏)"|>,
	47-><|"father"->"动画","name"->"短片/手书/配音"|>,
	50-><|"father"->"动画","name"->"短片/手书/配音(隐藏)"|>,
	51-><|"father"->"番剧","name"->"资讯"|>,
	53-><|"father"->"动画","name"->"综合(隐藏)"|>,
	54-><|"father"->"音乐","name"->"OP/ED/OST"|>,
	56-><|"father"->"音乐","name"->"VOCALOID(隐藏)"|>,
	59-><|"father"->"音乐","name"->"演奏"|>,
	60-><|"father"->"游戏","name"->"电子竞技(隐藏)"|>,
	65-><|"father"->"游戏","name"->"网络游戏"|>,
	67-><|"father"->"游戏","name"->"单机游戏(隐藏)"|>,
	71-><|"father"->"娱乐","name"->"综艺"|>,
	74-><|"father"->"生活","name"->"日常(隐藏)"|>,
	75-><|"father"->"生活","name"->"动物圈"|>,
	76-><|"father"->"生活","name"->"美食圈"|>,
	77-><|"father"->"生活","name"->"动物圈(隐藏)"|>,
	79-><|"father"->"生活","name"->"动物圈(隐藏)"|>,
	80-><|"father"->"生活","name"->"美食圈(隐藏)"|>,
	82-><|"father"->"电影","name"->"电影相关(隐藏)"|>,
	83-><|"father"->"电影","name"->"其他国家"|>,
	85-><|"father"->"影视","name"->"短片"|>,
	86-><|"father"->"影视","name"->"特摄"|>,
	94-><|"father"->"动画","name"->"完结动画(隐藏)"|>,
	95-><|"father"->"科技","name"->"数码"|>,
	96-><|"father"->"科技","name"->"星海"|>,
	98-><|"father"->"科技","name"->"机械"|>,
	114-><|"father"->"娱乐","name"->"综艺(隐藏)"|>,
	116-><|"father"->"未知","name"->"未知(隐藏)"|>,
	118-><|"father"->"未知","name"->"未知(隐藏)"|>,
	120-><|"father"->"动画","name"->"连载动画(隐藏)"|>,
	121-><|"father"->"游戏","name"->"GMV"|>,
	122-><|"father"->"科技","name"->"野生技术协会"|>,
	124-><|"father"->"科技","name"->"趣味科普人文"|>,
	125-><|"father"->"纪录片","name"->"人文历史(隐藏)"|>,
	126-><|"father"->"鬼畜","name"->"人力VOCALOID"|>,
	127-><|"father"->"鬼畜","name"->"教程演示"|>,
	128-><|"father"->"电视剧","name"->"电视剧相关(隐藏)"|>,
	130-><|"father"->"音乐","name"->"音乐选集"|>,
	131-><|"father"->"娱乐","name"->"Korea相关"|>,
	134-><|"father"->"娱乐","name"->"Korea相关(隐藏)"|>,
	135-><|"father"->"未知","name"->"未知(隐藏)"|>,
	136-><|"father"->"游戏","name"->"音游"|>,
	137-><|"father"->"娱乐","name"->"明星"|>,
	138-><|"father"->"生活","name"->"搞笑"|>,
	139-><|"father"->"游戏","name"->"网络游戏(隐藏)"|>,
	141-><|"father"->"游戏","name"->"游戏集锦(隐藏)"|>,
	145-><|"father"->"电影","name"->"欧美电影"|>,
	146-><|"father"->"电影","name"->"日本电影"|>,
	147-><|"father"->"电影","name"->"华语电影"|>,
	152-><|"father"->"番剧","name"->"官方延伸"|>,
	153-><|"father"->"国创","name"->"国产动画"|>,
	154-><|"father"->"舞蹈","name"->"三次元舞蹈"|>,
	156-><|"father"->"舞蹈","name"->"舞蹈教程"|>,
	157-><|"father"->"时尚","name"->"美妆"|>,
	158-><|"father"->"时尚","name"->"服饰"|>,
	159-><|"father"->"时尚","name"->"资讯"|>,
	161-><|"father"->"生活","name"->"手工"|>,
	162-><|"father"->"生活","name"->"绘画"|>,
	163-><|"father"->"生活","name"->"运动"|>,
	164-><|"father"->"时尚","name"->"健身"|>,
	166-><|"father"->"广告","name"->"广告"|>,
	168-><|"father"->"国创","name"->"国产原创相关"|>,
	169-><|"father"->"国创","name"->"布袋戏"|>,
	170-><|"father"->"国创","name"->"资讯"|>,
	171-><|"father"->"游戏","name"->"电子竞技"|>,
	172-><|"father"->"游戏","name"->"手机游戏"|>,
	173-><|"father"->"游戏","name"->"桌游棋牌"|>,
	174-><|"father"->"生活","name"->"其他"|>,
	175-><|"father"->"生活","name"->"ASMR"|>,
	176-><|"father"->"科技","name"->"汽车"|>,
	178-><|"father"->"纪录片","name"->"科学探索"|>,
	179-><|"father"->"纪录片","name"->"热血军事"|>,
	180-><|"father"->"纪录片","name"->"舌尖上的旅行"|>,
	182-><|"father"->"影视","name"->"影视杂谈"|>,
	183-><|"father"->"影视","name"->"影视剪辑"|>,
	184-><|"father"->"影视","name"->"预告 资讯"|>,
	185-><|"father"->"电视剧","name"->"国产剧"|>,
	187-><|"father"->"电视剧","name"->"海外剧"|>
|>;


$APIs=<|
	"PhotoHot"->Function[Table[$RawAPIs["photohot","url",#][<|"page"->i|>],{i,0,24}]]
	"PhotoRank"->Function[Through[Values[test["url"]][<|"time" -> #|>]]]
|>;
SetAttributes[
	{$RawAPIs,$RidList,$APIs},
	{Protected,ReadProtected}
];
End[];