_log = require 'ololog'

input = '''
'''

f = ( )->

try
	_log f input
catch e
	_log e
