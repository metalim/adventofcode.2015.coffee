_log = require 'ololog'

containers = [43,3,4,10,21,44,4,6,47,41,34,17,17,44,36,31,46,9,27,38].sort (a,b)->b-a

fill = ( cons, l )->
	out = []
	for c, i in cons when l-c >= 0
		if l-c is 0
			out.push [c]
		else
			for rem in fill cons[i+1..], l-c
				out.push [c, rem...]
	out

try
	perms = fill containers, 150
	_log perms.length
	min = perms.length
	for p in perms when p.length < min
		min = p.length
	min_perms = (p for p in perms when p.length is min)
	_log min_perms.length
	_log min_perms

catch e
	_log e
