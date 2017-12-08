_log = require 'ololog'

input = '''
To continue, please consult the code grid in the manual.  Enter the code at row 2978, column 3083.
'''

parse = ( input )->
	input.match(/(\d+)/g).map (a)->+a

next = ( n )->
	n * 252533 % 33554393

find_code = ( cy, cx )->
	code = 20151125
	x = y = 1
	while y isnt cy or x isnt cx
		code = next code
		if y is 1
			y = x+1
			x = 1
		else
			++x
			--y
	code


try
	_log.darkGray v = parse input
	_log.yellow find_code v[0], v[1]
	#_log.yellow find_code 5,5
catch e
	_log.red e
