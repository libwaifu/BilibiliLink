# 设计模式

## Install

如果你是开发者, 那么按照如下方式安装, 同时卸载用户版, 以免造成干扰.

接着打开如下或任意 `$Path` 目录
```haskell
PacletUninstall["BilibilliLink"]
SystemOpen[FileNameJoin@{$UserBaseDirectory, "Applications"}]
```
接着使用git下载以下, 或任意fork项目即可
```bash
git clone git@github.com:Moe-Net/BilibiliLink.git --depth 1
```

使用 `git pull` 同步, 使用`rm -rf BilibiliLink`命令删除即可卸载.

### Encoding

在开始一切之前, 请务必检查编码, 运行如下代码自动纠正编码.

```haskell
If[$CharacterEncoding=!="UTF-8",
	$CharacterEncoding="UTF-8";
	Print[{
		Style["$CharacterEncoding has changed to UTF-8 to avoid problems.",Red],
		Style["Because BilibiliLink only works under UTF-8"]
	}//TableForm];
	st=OpenAppend[FindFile["init.m"]];
	WriteString[st,"$CharacterEncoding=\"UTF-8\";"];
	Close[st];
];
```


---
## Dev

BBLink的核心部分就是`Package`目录, 所有**直接**在该目录下的 `*.m` 文件会被惰性加载, 也就是说 `__Feature__` 文件夹下的任何程序包都不会被默认加载, 所以一般测试功能, 过期功能都可以放里面
所有 `*.m` 文件都应该满足如下形式:
```haskell
TestFunction1::usage="测试函数, 最终函数名BillibiliLink`TestFunction1.";
Begin["`Test`"];
TestFunction1:="Test";
TestFunction2::usage="测试函数, 最终函数名BillibiliLink`Test`TestFunction2.";
TestFunction2:="Test";
End[]
```
也就是说所有在Begin前的声明会加载进整个包的上下文, 且能在不同的 `*.m` 文件中被共享, 在整个项目里被读取.
而Begin之后函数名则是局部的, 需要使用相对引用才能读取.
使用同名上下文惰性加载后会被识别为同一程序包, 请务必避免同名上下文里写同名函数.
***

## Test

BBLink对于单个单位使用函数(Function)操作, 对于多个单位使用对象(Object)操作. 例如对于单个视频, 有一系列的函数接收vid并返回相应的返回值, 而对于多个视频则采用BilibiliVideoSectionObject对象来封装.

面对对象的部分通常名字相当长, 但是不用担心, 一般不需要手动操作那个部分, BBLink 提供了一些UI来简化操作.

首先我们加载BBLink查看所有全局函数
```haskell
<< "BilibiliLink`"
?? BilibiliLink`*
(*?? BilibiliLink`*`**)
```

![TIM截图20180525112728.png](https://i.loli.net/2018/05/25/5b07835647a60.png)

然后查看Help函数, 最终会有一个BilibiliHelp 函数给出一个完整的UI封装, 现在将就用这个

![TIM截图20180525112739.png](https://i.loli.net/2018/05/25/5b078355eee98.png)

点击Copy, 然后传给`obj`, 运行后`obj`就相当于是一个函数, 能够接受参数
小写开头的字符串是短码, 短码不接受额外选项.
大写开头的是长码, 那就能和正常函数一样使用了.

![TIM截图20180525112806.png](https://i.loli.net/2018/05/25/5b0783567c456.png)

我们可以看到UI是Object的整合, Object是Function的整合, 所以其实熟练以后完全可以只用Function.
