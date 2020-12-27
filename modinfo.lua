name = "Better revival"
author = "CG"
version = "1.3.0"
description = [[send #R to revive and recover
send #RR to revive only
send #RS to reselect charactor
send #GG to commit suicide
ALL COMMANDS ABOVE IS CASE INSENSITIVE]]

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
		label = "Welcome tips show duration",
		hover = "Setting the welcome tips and help tips show duration, default is 4 secs",
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
		label = "Don't drop anything(except first slot)",
		hover = "Will drop your item in first slot so that your teammate can resurrect you.",
		options = 
		{
			{description = "ON", data = "on"},
			{description = "OFF", data = "off"},
		},
		default = "on",
	},
}