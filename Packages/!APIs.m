$BilibiliLinkUA::usage = "";
Begin["`APIs`"];


$RawAPIs = <|
	"archive" -> <|
		"url" -> StringTemplate["https://api.bilibili.com/x/web-interface/archive/stat?aid=`aid`"],
		"detail" -> ""
	|>,
	"arch" -> <|
		"url" -> StringTemplate["https://api.bilibili.com/archive_stat/stat?aid=`aid`"],
		"detail" -> "效果和archive接口相同."
	|>,
	"cid" -> <|
		"url" -> StringTemplate["http://www.bilibilijj.com/Api/AvToCid/`aid`/0"],
		"detail" -> "哔哩哔哩唧唧的cid查询端口, 本机必须使用apikeys或cookies才能得到."
	|>,
	"photohot" -> <|
		"url" -> <|
			"illustration" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=illustration&type=hot&page_num=`page`&page_size=20"],
			"comic" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=comic&type=hot&page_num=`page`&page_size=20"],
			"draw" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=draw&type=hot&page_num=`page`&page_size=20"],
			"all" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/list?category=all&type=hot&page_num=`page`&page_size=20"],
			"cos" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=cos&type=hot&page_num=`page`&page_size=20"],
			"sifu" -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Photo/list?category=sifu&type=hot&page_num=`page`&page_size=20"]
		|>,
		"detail" -> "h.bilibili.com的热门作品. 可选参数 page, 从0到24."
	|>,
	"photorank" -> <|
		"url" -> <|
			1 -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=1&rank_type=`time`&page_size=50"],
			2 -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=2&category=cos&rank_type=`time`&page_size=50"],
			3 -> StringTemplate["https://api.vc.bilibili.com/link_draw/v2/Doc/ranklist?biz=2&category=sifu&rank_type=`time`&page_size=50"]
		|>,
		"detail" -> "h.bilibili.com的排行榜. 可选参数 time, 有day, week, month三种取值."
	|>,
	"webshow" -> <|
		"url" -> <|
			"id" -> StringTemplate["https://api.bilibili.com/x/web-show/res/locs?pf=0&id=`id`"]
			"ids" -> StringTemplate["https://api.bilibili.com/x/web-show/res/locs?pf=0&ids=`ids`"]
		|>,
		"detail" -> "不明,可选参数见$LocPF0."
	|>,
	"vs" -> <|
		"url" -> StringTemplate["http://api.bilibili.com/x/web-interface/newlist?rid=`rid`"],
		"detail" -> "VideoSection, B站视频分区, rid 为分区编号, 详见下表 $RidList."
	|>,
	"vspage" -> <|
		"url" -> StringTemplate["http://api.bilibili.com/x/web-interface/newlist?rid=`rid`&pn=`pn`&ps=20&type=0"],
		"detail" -> "VideoSectionPage, pn 为页数, ps 为单页显示条目数, 锁死 20, tpye 用途不明"
	|>,
	"ar" -> <|
		"url" -> StringTemplate["https://api.bilibili.com/x/article/rank/list?cid=`cid`"],
		"detail" -> "ArticleRank, 专栏文章全站排名, cid 为时段, 可选值有四个:1, 月榜, 2, 周榜, 3, 昨日, 4, 前天",
		"from" -> "https://www.bilibili.com/read/ranking"
	|>,
	"captcha" -> <|
		"url" -> "https://passport.bilibili.com/captcha",
		"detail" -> "返回验证码"
	|>
|>;

(*未整理的API






https://api.bilibili.com/x/article/rank/list?cid=4

// tag用
URLExecute["https://api.bilibili.com/x/tag/ranking/archives?tag_id=6776132&rid=47&type=0&pn=1&ps=100","RawJson"]["data"]
https://api.bilibili.com/x/web-interface/ranking/tag?rid=47&tag_id=6776132


// 手机载入页面
http://app.bilibili.com/x/splash?plat=0&width=1080&height=1920
//IPHONE 和安卓一样
http://app.bilibili.com/x/splash?channel=appstore&height=1334&plat=1&width=750
//IPAD
http://app.bilibili.com/x/splash?channel=appstore&height=1536&plat=1&width=2048
*)



(* ::Subsection::Closed:: *)
(*Secret*)
(*https://github.com/Vespa314/bilibili-api/blob/master/api.md*)
$RidList = <|
	0 -> <|
		"name" -> "根目录",
		"url" -> "http://www.bilibili.com",
		"parent" -> Missing
	|>,
	1 -> <|
		"name" -> "动画",
		"url" -> "http://www.bilibili.com/video/douga.html",
		"parent" -> 0
	|>,
	3 -> <|
		"name" -> "音乐",
		"url" -> "http://www.bilibili.com/video/music.html",
		"parent" -> 0
	|>,
	4 -> <|
		"name" -> "游戏",
		"url" -> "http://www.bilibili.com/video/game.html",
		"parent" -> 0
	|>,
	5 -> <|
		"name" -> "娱乐",
		"url" -> "http://www.bilibili.com/video/ent.html",
		"parent" -> 0
	|>,
	9 -> <|
		"name" -> "意见留言簿",
		"url" -> "http://www.bilibili.complus/guestbook.php",
		"parent" -> 0
	|>,
	11 -> <|
		"name" -> "电视剧",
		"url" -> "http://www.bilibili.com/video/teleplay.html",
		"parent" -> 0
	|>,
	12 -> <|
		"name" -> "公告",
		"url" -> "http://www.bilibili.com/list.php?tid=",
		"parent" -> 0
	|>,
	13 -> <|
		"name" -> "番剧",
		"url" -> "http://www.bilibili.com/video/bangumi.html",
		"parent" -> 0
	|>,
	15 -> <|
		"name" -> "连载剧集",
		"url" -> "http://www.bilibili.com/video/soap-three-1.html",
		"parent" -> 11
	|>,
	16 -> <|
		"name" -> "flash游戏",
		"url" -> "http://www.bilibili.com/video/game-flash-1.html",
		"parent" -> 116
	|>,
	17 -> <|
		"name" -> "单机联机",
		"url" -> "http://www.bilibili.com/video/game-video-1.html",
		"parent" -> 116
	|>,
	18 -> <|
		"name" -> "游戏攻略\[CenterDot]解说",
		"url" -> "http://www.bilibili.com/video/game-ctary-1.html",
		"parent" -> 116
	|>,
	19 -> <|
		"name" -> "Mugen",
		"url" -> "http://www.bilibili.com/video/game-mugen-1.html",
		"parent" -> 116
	|>,
	20 -> <|
		"name" -> "ACG相关舞蹈",
		"url" -> "http://www.bilibili.com/video/dance-1.html",
		"parent" -> 129
	|>,
	21 -> <|
		"name" -> "生活",
		"url" -> "http://www.bilibili.com/video/ent-life-1.html",
		"parent" -> 5
	|>,
	22 -> <|
		"name" -> "三次元鬼畜",
		"url" -> "http://www.bilibili.com/video/ent-Kichiku-1.html",
		"parent" -> 119
	|>,
	23 -> <|
		"name" -> "电影",
		"url" -> "http://www.bilibili.com/video/movie.html",
		"parent" -> 0
	|>,
	24 -> <|
		"name" -> "MAD\[CenterDot]AMV",
		"url" -> "http://www.bilibili.com/video/douga-mad-1.html",
		"parent" -> 1
	|>,
	25 -> <|
		"name" -> "MMD\[CenterDot]3D",
		"url" -> "http://www.bilibili.com/video/douga-mmd-1.html",
		"parent" -> 1
	|>,
	26 -> <|
		"name" -> "二次元鬼畜",
		"url" -> "http://www.bilibili.com/video/douga-kichiku-1.html",
		"parent" -> 119
	|>,
	27 -> <|
		"name" -> "综合",
		"url" -> "http://www.bilibili.com/video/douga-else-1.html",
		"parent" -> 1
	|>,
	28 -> <|
		"name" -> "同人音乐",
		"url" -> "http://www.bilibili.com/video/music-video-1.html",
		"parent" -> 117
	|>,
	29 -> <|
		"name" -> "三次元音乐",
		"url" -> "http://www.bilibili.com/video/music-coordinate-1.html",
		"parent" -> 117
	|>,
	30 -> <|
		"name" -> "VOCALOID\[CenterDot]UTAU",
		"url" -> "http://www.bilibili.com/video/music-vocaloid-1.html",
		"parent" -> 117
	|>,
	31 -> <|
		"name" -> "翻唱",
		"url" -> "http://www.bilibili.com/video/music-Cover-1.html",
		"parent" -> 117
	|>,
	32 -> <|
		"name" -> "完结动画",
		"url" -> "http://www.bilibili.com/video/part-twoelement-1.html",
		"parent" -> 13
	|>,
	33 -> <|
		"name" -> "连载动画",
		"url" -> "http://www.bilibili.com/video/bangumi-two-1.html",
		"parent" -> 13
	|>,
	34 -> <|
		"name" -> "完结剧集",
		"url" -> "http://www.bilibili.com/video/tv-drama-1.html",
		"parent" -> 11
	|>,
	36 -> <|
		"name" -> "科技",
		"url" -> "http://www.bilibili.com/video/technology.html",
		"parent" -> 0
	|>,
	37 -> <|
		"name" -> "纪录片",
		"url" -> "http://www.bilibili.com/video/tech-popular-science-1.html",
		"parent" -> 36
	|>,
	39 -> <|
		"name" -> "演讲\[Bullet]公开课",
		"url" -> "http://www.bilibili.com/video/speech-course-1.html",
		"parent" -> 36
	|>,
	40 -> <|
		"name" -> "技术宅",
		"url" -> "http://www.bilibili.com/video/tech-otaku-1.html",
		"parent" -> 122
	|>,
	41 -> <|
		"name" -> "暂置区",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 12
	|>,
	43 -> <|
		"name" -> "舞蹈MMD",
		"url" -> "http://www.bilibili.com/video/mmd-dance-1.html",
		"parent" -> 25
	|>,
	44 -> <|
		"name" -> "剧情MMD",
		"url" -> "http://www.bilibili.com/video/mmd-story-1.html",
		"parent" -> 25
	|>,
	45 -> <|
		"name" -> "原创模型",
		"url" -> "http://www.bilibili.com/video/mmd-original-1.html",
		"parent" -> 25
	|>,
	46 -> <|
		"name" -> "其他视频",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 25
	|>,
	47 -> <|
		"name" -> "动画短片",
		"url" -> "http://www.bilibili.com/video/douga-voice-1.html",
		"parent" -> 1
	|>,
	48 -> <|
		"name" -> "原创动画",
		"url" -> "http://www.bilibili.com/video/douga-voice-original-1.html",
		"parent" -> 47
	|>,
	49 -> <|
		"name" -> "ACG配音",
		"url" -> "http://www.bilibili.com/video/douga-voice-translate-1.html",
		"parent" -> 27
	|>,
	50 -> <|
		"name" -> "手书",
		"url" -> "http://www.bilibili.com/video/douga-else-handwriting-1.html",
		"parent" -> 27
	|>,
	51 -> <|
		"name" -> "资讯",
		"url" -> "http://www.bilibili.com/video/douga-else-information-1.html",
		"parent" -> 13
	|>,
	52 -> <|
		"name" -> "动漫杂谈",
		"url" -> "http://www.bilibili.com/video/douga-else-tattle-1.html",
		"parent" -> 27
	|>,
	53 -> <|
		"name" -> "其他动漫",
		"url" -> "http://www.bilibili.com/video/douga-else-other-1.html",
		"parent" -> 27
	|>,
	54 -> <|
		"name" -> "OP/ED/OST",
		"url" -> "http://www.bilibili.com/video/music-oped-1.html",
		"parent" -> 117
	|>,
	55 -> <|
		"name" -> "其他音乐",
		"url" -> "http://www.bilibili.com/video/music-video-other-1.html",
		"parent" -> 28
	|>,
	56 -> <|
		"name" -> "VOCALOID",
		"url" -> "http://www.bilibili.com/video/music-vocaloid-vocaloid-1.html",
		"parent" -> 30
	|>,
	57 -> <|
		"name" -> "UTAU",
		"url" -> "http://www.bilibili.com/video/music-vocaloid-utau-1.html",
		"parent" -> 30
	|>,
	58 -> <|
		"name" -> "VOCALOID中文曲",
		"url" -> "http://www.bilibili.com/video/music-vocaloid-chinese-1.html",
		"parent" -> 30
	|>,
	59 -> <|
		"name" -> "演奏",
		"url" -> "http://www.bilibili.com/video/music-perform-1.html",
		"parent" -> 117
	|>,
	60 -> <|
		"name" -> "电子竞技",
		"url" -> "http://www.bilibili.com/video/game-fight-1.html",
		"parent" -> 116
	|>,
	61 -> <|
		"name" -> "预告资讯",
		"url" -> "http://www.bilibili.com/video/game-presentation-1.html",
		"parent" -> 17
	|>,
	63 -> <|
		"name" -> "实况解说",
		"url" -> "http://www.bilibili.com/video/game-video-other-1.html",
		"parent" -> 17
	|>,
	64 -> <|
		"name" -> "游戏杂谈",
		"url" -> "http://www.bilibili.com/video/game-ctary-standalone-1.html",
		"parent" -> 17
	|>,
	65 -> <|
		"name" -> "网络游戏",
		"url" -> "http://www.bilibili.com/video/game-ctary-network-1.html",
		"parent" -> 116
	|>,
	66 -> <|
		"name" -> "游戏集锦",
		"url" -> "http://www.bilibili.com/video/game-ctary-handheld-1.html",
		"parent" -> 17
	|>,
	67 -> <|
		"name" -> "其他游戏",
		"url" -> "http://www.bilibili.com/video/game-ctary-other-1.html",
		"parent" -> 17
	|>,
	68 -> <|
		"name" -> "电竞赛事",
		"url" -> "http://www.bilibili.com/video/game-fight-matches-1.html",
		"parent" -> 60
	|>,
	69 -> <|
		"name" -> "实况解说",
		"url" -> "http://www.bilibili.com/video/game-fight-explain-1.html",
		"parent" -> 60
	|>,
	70 -> <|
		"name" -> "游戏集锦",
		"url" -> "http://www.bilibili.com/video/game-fight-other-1.html",
		"parent" -> 60
	|>,
	71 -> <|
		"name" -> "综艺",
		"url" -> "http://www.bilibili.com/video/ent-variety-1.html",
		"parent" -> 5
	|>,
	72 -> <|
		"name" -> "运动",
		"url" -> "http://www.bilibili.com/video/ent-sports-1.html",
		"parent" -> 21
	|>,
	73 -> <|
		"name" -> "影视剪影",
		"url" -> "http://www.bilibili.com/video/ent-silhouette-1.html",
		"parent" -> 128
	|>,
	74 -> <|
		"name" -> "日常",
		"url" -> "http://www.bilibili.com/video/ent-life-other-1.html",
		"parent" -> 21
	|>,
	75 -> <|
		"name" -> "动物圈",
		"url" -> "http://www.bilibili.com/video/ent-animal-1.html",
		"parent" -> 5
	|>,
	76 -> <|
		"name" -> "美食圈",
		"url" -> "http://www.bilibili.com/video/ent-food-1.html",
		"parent" -> 5
	|>,
	77 -> <|
		"name" -> "喵星人",
		"url" -> "http://www.bilibili.com/video/ent-animal-cat-1.html",
		"parent" -> 75
	|>,
	78 -> <|
		"name" -> "汪星人",
		"url" -> "http://www.bilibili.com/video/ent-animal-dog-1.html",
		"parent" -> 75
	|>,
	79 -> <|
		"name" -> "其他动物",
		"url" -> "http://www.bilibili.com/video/ent-animal-other-1.html",
		"parent" -> 75
	|>,
	80 -> <|
		"name" -> "美食视频",
		"url" -> "http://www.bilibili.com/video/ent-food-video-1.html",
		"parent" -> 76
	|>,
	81 -> <|
		"name" -> "料理制作",
		"url" -> "http://www.bilibili.com/video/ent-food-course-1.html",
		"parent" -> 76
	|>,
	82 -> <|
		"name" -> "电影相关",
		"url" -> "http://www.bilibili.com/video/movie-presentation-1.html",
		"parent" -> 23
	|>,
	83 -> <|
		"name" -> "其他国家",
		"url" -> "http://www.bilibili.com/video/movie-movie-1.html",
		"parent" -> 23
	|>,
	85 -> <|
		"name" -> "短片",
		"url" -> "http://www.bilibili.com/video/tv-micromovie-1.html",
		"parent" -> 23
	|>,
	86 -> <|
		"name" -> "特摄\[CenterDot]布袋",
		"url" -> "http://www.bilibili.com/video/tv-sfx-1.html",
		"parent" -> 11
	|>,
	87 -> <|
		"name" -> "国产",
		"url" -> "http://www.bilibili.com/video/tv-drama-cn-1.html",
		"parent" -> 34
	|>,
	88 -> <|
		"name" -> "日剧",
		"url" -> "http://www.bilibili.com/video/tv-drama-jp-1.html",
		"parent" -> 34
	|>,
	89 -> <|
		"name" -> "美剧",
		"url" -> "http://www.bilibili.com/video/tv-drama-us-1.html",
		"parent" -> 34
	|>,
	90 -> <|
		"name" -> "其他TV",
		"url" -> "http://www.bilibili.com/video/tv-drama-other-1.html",
		"parent" -> 34
	|>,
	91 -> <|
		"name" -> "特摄",
		"url" -> "http://www.bilibili.com/video/tv-sfx-sfx-1.html",
		"parent" -> 86
	|>,
	92 -> <|
		"name" -> "布袋戏",
		"url" -> "http://www.bilibili.com/video/tv-sfx-pili-1.html",
		"parent" -> 86
	|>,
	94 -> <|
		"name" -> "剧场版",
		"url" -> "http://www.bilibili.com/video/bangumi-ova-1.html",
		"parent" -> 32
	|>,
	95 -> <|
		"name" -> "数码",
		"url" -> "http://www.bilibili.com/video/tech-future-digital-1.html",
		"parent" -> 36
	|>,
	96 -> <|
		"name" -> "军事",
		"url" -> "http://www.bilibili.com/video/tech-future-military-1.html",
		"parent" -> 36
	|>,
	97 -> <|
		"name" -> "手机评测",
		"url" -> "http://www.bilibili.com/video/tech-future-mobile-1.html",
		"parent" -> 95
	|>,
	98 -> <|
		"name" -> "机械",
		"url" -> "http://www.bilibili.com/video/tech-future-other-1.html",
		"parent" -> 36
	|>,
	99 -> <|
		"name" -> "BBC纪录片",
		"url" -> "http://www.bilibili.com/video/tech-geo-bbc-1.html",
		"parent" -> 37
	|>,
	100 -> <|
		"name" -> "探索频道",
		"url" -> "http://www.bilibili.com/video/tech-geo-discovery-1.html",
		"parent" -> 37
	|>,
	101 -> <|
		"name" -> "国家地理",
		"url" -> "http://www.bilibili.com/video/tech-geo-national-1.html",
		"parent" -> 37
	|>,
	102 -> <|
		"name" -> "NHK",
		"url" -> "http://www.bilibili.com/video/tech-geo-nhk-1.html",
		"parent" -> 37
	|>,
	103 -> <|
		"name" -> "演讲",
		"url" -> "http://www.bilibili.com/video/speech-1.html",
		"parent" -> 39
	|>,
	104 -> <|
		"name" -> "公开课",
		"url" -> "http://www.bilibili.com/video/course-1.html",
		"parent" -> 39
	|>,
	105 -> <|
		"name" -> "演示",
		"url" -> "http://www.bilibili.com/video/tech-geo-course-1.html",
		"parent" -> 122
	|>,
	107 -> <|
		"name" -> "科技人文",
		"url" -> "http://www.bilibili.com/video/tech-humanity-1.html",
		"parent" -> 124
	|>,
	108 -> <|
		"name" -> "趣味短片",
		"url" -> "http://www.bilibili.com/video/tech-funvideo-1.html",
		"parent" -> 124
	|>,
	110 -> <|
		"name" -> "国产",
		"url" -> "http://www.bilibili.com/video/soap-three-cn-1.html",
		"parent" -> 15
	|>,
	111 -> <|
		"name" -> "日剧",
		"url" -> "http://www.bilibili.com/video/soap-three-jp-1.html",
		"parent" -> 15
	|>,
	112 -> <|
		"name" -> "美剧",
		"url" -> "http://www.bilibili.com/video/soap-three-us-1.html",
		"parent" -> 15
	|>,
	113 -> <|
		"name" -> "其他电视剧",
		"url" -> "http://www.bilibili.com/video/soap-three-oth-1.html",
		"parent" -> 15
	|>,
	114 -> <|
		"name" -> "国内综艺",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 71
	|>,
	115 -> <|
		"name" -> "国外综艺",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 71
	|>,
	116 -> <|
		"name" -> "游戏",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 12
	|>,
	117 -> <|
		"name" -> "音乐",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 12
	|>,
	118 -> <|
		"name" -> "其他",
		"url" -> "http://www.bilibili.com/video/index.html",
		"parent" -> 12
	|>,
	119 -> <|
		"name" -> "鬼畜",
		"url" -> "http://www.bilibili.com/video/kichiku.html",
		"parent" -> 0
	|>,
	120 -> <|
		"name" -> "剧场版",
		"url" -> "http://www.bilibili.com/video/newbangumi-ova-1.html",
		"parent" -> 33
	|>,
	121 -> <|
		"name" -> "GMV",
		"url" -> "http://www.bilibili.com/video/gmv-1.html",
		"parent" -> 116
	|>,
	122 -> <|
		"name" -> "野生技术协会",
		"url" -> "http://www.bilibili.com/video/tech-wild-1.html",
		"parent" -> 36
	|>,
	123 -> <|
		"name" -> "手办模型",
		"url" -> "http://www.bilibili.com/video/figure-1.html",
		"parent" -> 122
	|>,
	124 -> <|
		"name" -> "趣味科普人文",
		"url" -> "http://www.bilibili.com/video/tech-fun-1.html",
		"parent" -> 36
	|>,
	125 -> <|
		"name" -> "其他",
		"url" -> "http://www.bilibili.com/video/tech-geo-other-1.html",
		"parent" -> 37
	|>,
	126 -> <|
		"name" -> "人力VOCALOID",
		"url" -> "http://www.bilibili.com/video/kichiku-manual_vocaloid-1.html",
		"parent" -> 119
	|>,
	127 -> <|
		"name" -> "教程演示",
		"url" -> "http://www.bilibili.com/video/kichiku-course-1.html",
		"parent" -> 119
	|>,
	128 -> <|
		"name" -> "电视剧相关",
		"url" -> "http://www.bilibili.com/video/tv-presentation-1.html",
		"parent" -> 11
	|>,
	129 -> <|
		"name" -> "舞蹈",
		"url" -> "http://www.bilibili.com/video/dance.html",
		"parent" -> 0
	|>,
	130 -> <|
		"name" -> "音乐选集",
		"url" -> "http://www.bilibili.com/video/music-collection-1.html",
		"parent" -> 117
	|>,
	131 -> <|
		"name" -> "Korea相关",
		"url" -> "http://www.bilibili.com/video/ent-korea-1.html",
		"parent" -> 5
	|>,
	132 -> <|
		"name" -> "Korea音乐舞蹈",
		"url" -> "http://www.bilibili.com/video/ent-korea-music-dance-1.html",
		"parent" -> 131
	|>,
	133 -> <|
		"name" -> "Korea综艺",
		"url" -> "http://www.bilibili.com/video/ent-korea-variety-1.html",
		"parent" -> 131
	|>,
	134 -> <|
		"name" -> "其他",
		"url" -> "http://www.bilibili.com/video/ent-korea-other-1.html",
		"parent" -> 131
	|>,
	135 -> <|
		"name" -> "活动",
		"url" -> "http://www.bilibili.com/video/video/activities.html",
		"parent" -> 0
	|>,
	136 -> <|
		"name" -> "音游",
		"url" -> "http://www.bilibili.com/video/music-game-1.html",
		"parent" -> 116
	|>,
	137 -> <|
		"name" -> "娱乐圈",
		"url" -> "http://www.bilibili.com/video/ent-circle-1.html",
		"parent" -> 5
	|>,
	138 -> <|
		"name" -> "搞笑",
		"url" -> "http://www.bilibili.com/video/ent_funny_1.html",
		"parent" -> 5
	|>,
	139 -> <|
		"name" -> "实况解说",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 65
	|>,
	140 -> <|
		"name" -> "游戏杂谈",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 65
	|>,
	141 -> <|
		"name" -> "游戏集锦",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 65
	|>,
	142 -> <|
		"name" -> "漫展",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 21
	|>,
	143 -> <|
		"name" -> "COSPLAY",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 21
	|>,
	144 -> <|
		"name" -> "综艺剪辑",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 71
	|>,
	145 -> <|
		"name" -> "欧美电影",
		"url" -> "http://www.bilibili.com/video/movie_west_1.html",
		"parent" -> 23
	|>,
	146 -> <|
		"name" -> "日本电影",
		"url" -> "http://www.bilibili.com/video/movie_japan_1.html",
		"parent" -> 23
	|>,
	147 -> <|
		"name" -> "国产电影",
		"url" -> "http://www.bilibili.com/video/movie_chinese_1.html",
		"parent" -> 23
	|>,
	148 -> <|
		"name" -> "TV动画",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 33
	|>,
	149 -> <|
		"name" -> "OVA\[CenterDot]OAD",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 33
	|>,
	150 -> <|
		"name" -> "TV动画",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 32
	|>,
	151 -> <|
		"name" -> "OVA\[CenterDot]OAD",
		"url" -> "http://www.bilibili.com/video/list__1.html",
		"parent" -> 32
	|>,
	152 -> <|
		"name" -> "官方延伸",
		"url" -> "http://www.bilibili.com/video/bagumi_offical_1.html",
		"parent" -> 13
	|>,
	153 -> <|
		"name" -> "国产动画",
		"url" -> "http://www.bilibili.com/video/bangumi_chinese_1.html",
		"parent" -> 13
	|>,
	154 -> <|
		"name" -> "三次元舞蹈",
		"url" -> "http://www.bilibili.com/video/three-dimension-dance-1.html",
		"parent" -> 129
	|>
|>;

(* 编号全靠口胡, 服气
URLExecute["https://api.bilibili.com/x/web-show/res/locs?pf=0&ids="<>StringJoin@StringRiffle[ToString /@ Range[1, 10000], ","], "RawJSON"]
StringRiffle[Keys[%["data"]], ","] // Sort*)
$LocPF0 = "21,23,29,31,34,40,42,44,52,58,64,70,76,82,88,94,
	100,106,112,118,124,126,128,130,132,134,136,138,142,
	148,151,152,153,160,162,243,245,247,249,251,253,255,
	257,259,261,263,265,267,269,271,273,275,277,279,281,
	283,285,287,289,291,293,295,395,403,405,406,412,413,
	414,415,417,418,419,1466,1550,1554,1556,1558,1560,1562,
	1564,1566,1568,1570,1572,1574,1576,1578,1580,1582,1584,
	1586,1588,1590,1592,1594,1596,1598,1600,1602,1604,1606,
	1608,1610,1612,1614,1616,1618,1620,1622,1624,1626,1628,
	1630,1632,1634,1636,1660,1666,1670,1674,1680,1682,1919,
	1920,1921,1922,1923,1966,2034,2047,2048,2057,2058,2061,
	2062,2065,2066,2067,2078,2079,2207,2210,2211,2212,2213,
	2214,2257,2260,2261,2262,2263,2264,2307,2308,2309,2319,
	2341,2343,2345,2403,2452,2453,2462,2463,2472,2473,2482,
	2483,2492,2493,2503";

(* ::Subsection::Closed:: *)
(*Secret*)
$Secrets::usage = "官方key注册通道已经关闭\r
	虽然可以用黑科技注入, 但是已经搞不到高权限的key了\r
	所以只能用现有的开源方案来搞了, 这些key来自\r
	https://github.com/search?q=bilibili+appkey&type=Code";
$Secrets = {
	<|
		"AppKey" -> "84956560bc028eb7",
		"Source" -> "soimort/you-get",
		"LastTest" -> "No Test"
	|>,
	<|
		"AppKey" -> "f3bb208b3d081dc8",
		"Secret" -> "1c15888dc316e05a15fdd0a02ed6584f"
		"Source" -> "MoePlayer/DPlayer-API",
		"LastTest" -> "Success when 20180513"
	|>

};



$APIs = <|
	"PhotoHot" -> Function[Table[$RawAPIs["photohot", "url", #][<|"page" -> i|>], {i, 0, 24}]],
	"PhotoRank" -> Function[Through[Values[$RawAPIs["photorank", "url"]][<|"time" -> #|>]]],
	"RidList" -> $RidList,
	"VideoSection" -> Function[$RawAPIs["vs"]["rid" -> #]]
|>;
SetAttributes[
	{$RawAPIs, $RidList, $APIs},
	{Protected, ReadProtected}
];
End[];