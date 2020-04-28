# https://ipython.org/ipython-doc/stable/config/options/terminal.html

c = get_config()

c.TerminalIPythonApp.display_banner = True
#c.TerminalInteractiveShell.deep_reload = True

c.InteractiveShellApp.log_level = 30
c.InteractiveShellApp.extensions = [
#	'myextension'
]
c.InteractiveShellApp.exec_lines = [
#	'import numpy',
#	'import scipy'
]
c.InteractiveShellApp.exec_files = [
#	'mycode.py',
#	'fancy.ipy'
]
c.InteractiveShell.autoindent = True
c.InteractiveShell.colors = 'Linux'
c.InteractiveShell.confirm_exit = False
c.InteractiveShell.editor = 'vi'
c.InteractiveShell.xmode = 'Context'

c.PrefilterManager.multi_line_specials = True

c.AliasManager.user_aliases = [
	('ll', 'ls -laF'),
	('lt', 'ls -laFtr')
]
