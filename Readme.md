# BilibiliLink — 乾杯 - ( ゜ᴗ ゜)つロ

[![Build Status](https://travis-ci.org/GalAster/BilibiliLink.svg?branch=master)](https://travis-ci.org/GalAster/BilibiliLink)
[![Mathematica](https://img.shields.io/badge/Mathematica-%3E%3D11.3-brightgreen.svg)](https://www.wolfram.com/mathematica/)
[![Release Vision](https://img.shields.io/badge/release-v0.2.0-ff69b4.svg)](https://github.com/GalAster/BilibiliLink/releases)
[![Repo Size](https://img.shields.io/github/repo-size/GalAster/BilibiliLink.svg)](https://github.com/GalAster/BilibiliLink.git)

![创始四图](https://i.loli.net/2018/05/12/5af6f45da50ab.jpg)

#### 手动安装

打开目录:

`SystemOpen[FileNameJoin@{$UserBaseDirectory, "Applications"}]`

下载项目:

`git clone git@github.com:GalAster/BilibiliLink.git`

重启Mathematica并运行: ``<< "BilibiliLink`"``

#### 快速测试

```mma
PhotosLeaderboard["help"]
link = PhotosLeaderboard["日榜"]
link["Markdown"]
```