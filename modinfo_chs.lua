name = "更好的复活"
author = "CG"
version = "1.3.0"
description = [[
1.3.0: 增加了死亡不掉落功能，注意不要和其他类似功能的ｍｏｄ同时使用
1.2.5: 游戏内提示重新改为中文
1.2.3: 修复饥荒更新后发送消息游戏会崩溃bug
1.2: #r现在会重置黑血
1.1: 修复大写不识别bug
按Y(公聊)或U(私聊)输入指令：
#R来复活并回满状态
#RR来复活
#RS来重选人物
#GG来自杀
以上指令均不区分大小写
]]

icon_atlas = "modicon.xml"
icon = "icon.tex"

api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_only_mod = true

configuration_options = {
    {
		name = "MOD_WELCOME_TIPS_DURATION",
		label = "帮助信息显示（秒）",
		hover = "设置帮助信息显示时间，默认为四秒",
		options =
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
		},
		default = 5,
	},
	{
		name = "MOD_DONT_DROP",
		label = "死亡不掉落（会掉落第一个格子里的东西）",
		hover = "掉落第一个格子里的东西，以便于队友帮你复活",
		options = 
		{
			{description = "开", data = "on"},
			{description = "关", data = "off"},
		},
		default = "on",
	},
}