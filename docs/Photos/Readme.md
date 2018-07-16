# Functions


## PhotosRange
参数: list, 从一个pid列表中获取数据.

返回: AlbumObject对象

简写: 单个整数n表示`Range[1,n]`, 两个整数n则表示`Range[a,b]`

### 选项:
- RawData->False
    - 是否不转化为AlbumObject而返回接受到的原始数据
---
## PhotosIndex
1. 参数: 无
获得画友首页的推荐拼图
2. 返回: AlbumObject对象

**无选项**

## PhotosNew
- 参数: `Integer`

- 返回: `BilibiliAlbumObject`

- 选项
 - UpTo: `100`
 - Count: `False`
 - All: `False`
严重bug, 勿用
 - RawData `False`
Debug , 不转换生成 Object, 直接返回原始读入.

## PhotosHot


## PhotosRank

## PhotosRecommend

## PhotosTag

## PhotosAuthor

## PhotosSearch

## PhotosTrace

## PhotosDetail




具体实现参考 https://github.com/Moe-Net/BilibiliLink/issues/7


### Bug

![](/Readme/20180715090728449.png)

已知错误