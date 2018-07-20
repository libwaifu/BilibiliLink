# Functions


## TagInfo

### 参数
1. Integer, 代表需要查询的标签 id
2. List, 代表标签 id 列表

### 选项
无

### 返回值

```haskell
<|
	"ID"->"tag ID 简称 tid",
	"Name"->"tag 的名字",
	"Detail"->"tag 的描述, 没有的话为空",
	"Date"->"tag 的创建日期",
	"Count"->"使用了该 tag 的视频数",
	"Watch"->"关注了该 tag 的人数"
|>
```


::: tip ### 压力测试
每分钟 378 次请求后被封 ip 10 分钟

建议爬取速度, 每 ip 每分钟 240 次.
:::
