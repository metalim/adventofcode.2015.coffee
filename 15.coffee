_log = require 'ololog'

input = '''
Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
Candy: capacity 0, durability 5, flavor -1, texture 0, calories 8
Butterscotch: capacity -1, durability 0, flavor 5, texture 0, calories 6
Sugar: capacity 0, durability 0, flavor -2, texture 2, calories 1
'''.split '\n'

W = 4 #ignore calories and name
get_score = ( sp, r )->
	H = sp.length
	score = 1
	for i in [0...W]
		v = 0
		for j in [0...H]
			v+= r[j] * sp[j][i]
		v=0 if v<0
		score *= v
	score

r_in = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/

parse_spec = ( input )->
	for str in input
		r = r_in.exec str
		[+r[2],+r[3],+r[4],+r[5],+r[6]]

balance_recipe = ( spec, limit )->
	H = spec.length
	recipe = Array(H).fill 100//H
	recipe[0] += 100 - 100//H*H
	_log recipe

	score = get_score spec, recipe
	for d in [1...H]
		for i in [0...H]
			for dir in [-1,1]
				while yes
					next = recipe[..]
					next[i]++
					next[(i+d)%%H]--
					next_score = get_score spec, next
					if next_score < score
						break
					recipe = next
					score = next_score
	_log recipe
	score

try
	spec = parse_spec input
	_log spec
	#_log get_score spec, [25,25,26,24]
	_log balance_recipe spec, 100
catch e
	_log e
