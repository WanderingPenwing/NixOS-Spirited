require('dashboard').setup {
	theme = 'doom',
	config = {
		header = {
			'',
			'',
			'        ░░      ',
			'      ██░░      ',
			'    ▓▓██        ',
			'    ████        ',
			'    ████░░██    ',
			'    ██▒▒██▒▒██  ',
			'  ████▒▒░░▒▒██  ',
			'  ██▒▒░░░░▒▒████',
			'  ██▒▒░░░░░░▒▒██',
			'  ▓▓▒▒▒▒░░▒▒▒▒██',
			'  ▒▒▓▓▒▒▒▒▒▒▓▓▒▒',
			'    ░░██████░░  ',
			'',
			'',
		}, --your header
		center = {
			{
				icon = '  ',
				desc = 'Find File           ',
				key = 'f',
				keymap = '',
				key_format = ' %s', -- remove default surrounding `[]`
				action = 'ene | Telescope find_files'
			},
			{
				icon = '  ',
				desc = 'New File',
				key = 'n',
				keymap = '',
				key_format = ' %s', -- remove default surrounding `[]`
				action = 'ene | startinsert'
			},
		},
		footer = {}  --your footer
	}
}
