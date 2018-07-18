module.exports = {
	dest: 'docs/.build',
	locales: {
		'/': {
			lang: 'zh-CN',
			title: 'BBLink',
			description: 'Bilibili Connection Established!'
		}
	},
	serviceWorker: true,
	themeConfig: {
		repo: 'Moe-Net/BilibiliLink',
		editLinks: true,
		docsDir: 'docs',
		markdown: {
			lineNumbers: true
		},
		sidebar: [
			{
				title: '简介',
				children: [
					'/Start/',
					'/Start/Design.md',
					'/Start/Guide.md'
				]
			},
			{
				title: '画友站',
				children: [
					'/Photo/',
					'/Photo/Object.md'
				]
			},
			{
				title: '视频站',
				children: [
					'/Video/',
					'/Video/Object.md'
				]
			},
			{
				title: '小功能',
				children: [
					'/Toys/'
				]
			},
			{
				title: '全站爬虫',
				children: [
					'/Crawler/',
					'/Crawler/Video.md'

				]
			}
		]
	}
};
