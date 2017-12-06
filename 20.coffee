_log = require 'ololog'

input = 29000000

find_first_house_getting = ( goal )->
	n = 1
	max = 0
	while yes
		pres = 0
		for i in [1..n]
			if n%i is 0
				pres += i*10
		if pres >= goal
			return n
		if max < pres
			max = pres
			_log.darkGray n, pres
		++n
	return

find_first_house_getting2 = ( goal )->
	n = 1
	max_pres = 0
	while yes
		min = Math.max 1, n//50
		max = n//2
		pres = n*11
		for i in [min..max]
			if n%i is 0
				pres += i*11
		if pres >= goal
			return n
		if max_pres < pres
			max_pres = pres
			_log.darkGray n, pres
		++n
	return

try
	#_log.green find_first_house_getting input
	_log.green find_first_house_getting2 input

catch e
	_log.red e
