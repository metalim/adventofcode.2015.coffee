{_log, permute} = require './util'

input = '''
Faerun to Tristram = 65
Faerun to Tambi = 129
Faerun to Norrath = 144
Faerun to Snowdin = 71
Faerun to Straylight = 137
Faerun to AlphaCentauri = 3
Faerun to Arbre = 149
Tristram to Tambi = 63
Tristram to Norrath = 4
Tristram to Snowdin = 105
Tristram to Straylight = 125
Tristram to AlphaCentauri = 55
Tristram to Arbre = 14
Tambi to Norrath = 68
Tambi to Snowdin = 52
Tambi to Straylight = 65
Tambi to AlphaCentauri = 22
Tambi to Arbre = 143
Norrath to Snowdin = 8
Norrath to Straylight = 23
Norrath to AlphaCentauri = 136
Norrath to Arbre = 115
Snowdin to Straylight = 101
Snowdin to AlphaCentauri = 84
Snowdin to Arbre = 96
Straylight to AlphaCentauri = 107
Straylight to Arbre = 14
AlphaCentauri to Arbre = 46
'''.split '\n'


create_routes = ( spec )->
	routes = {}
	for s in spec
		res = /(\w+) to (\w+) = (\d+)/.exec s
		routes[res[1]]?={}
		routes[res[2]]?={}
		routes[res[1]][res[2]] = +res[3]
		routes[res[2]][res[1]] = +res[3]
	routes

shortest_path = ( routes )->
	min = Infinity
	max = 0

	permute Object.keys(routes), ( p )->
		dist = 0
		for a, i in p when (b=p[i+1])?
			return if not routes[a][b]?
			dist += routes[a][b]
		if dist < min
			min = dist
		if dist > max
			max = dist
		return
	[min,max]

routes = create_routes input
_log key, Object.keys(val).length for key, val of routes
_log shortest_path routes

