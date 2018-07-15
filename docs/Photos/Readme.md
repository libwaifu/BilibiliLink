## Install

如果你是开发者, 那么按照如下方式安装, 同时卸载用户版, 以免造成干扰.

接着打开如下或任意 `$Path` 目录
```mma
PacletUninstall["BilibilliLink"]
SystemOpen[FileNameJoin@{$UserBaseDirectory, "Applications"}]
```
接着使用git下载以下, 或任意fork项目即可
```sh
git clone git@github.com:Moe-Net/BilibiliLink.git --depth 1
```

使用 `git pull` 同步, 使用`rm -rf BilibiliLink`命令删除即可卸载.

### Encoding

在开始一切之前, 请务必检查编码, 运行如下代码自动纠正编码.

```mma
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


