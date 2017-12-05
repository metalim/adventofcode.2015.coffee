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

get_callories = ( sp, r )->
	H = sp.length
	cal = 0
	for i in [0...H]
		cal += r[i] * sp[i][4]
	cal

r_in = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/

parse_spec = ( input )->
	for str in input
		r = r_in.exec str
		[+r[2],+r[3],+r[4],+r[5],+r[6]]

balance_recipe = ( spec )->
	H = spec.length
	recipe = Array(H).fill 100//H
	recipe[0] += 100 - 100//H*H
	show_recipe spec, recipe

	score = get_score spec, recipe
	cal = get_callories spec, recipe
	steps = 0
	adjustments = 0
	for d in [1...H]
		for i in [0...H]
			for dir in [-1,1]
				while yes
					++steps
					next = recipe[..]
					next[i]++
					next[(i+d)%%H]--
					next_score = get_score spec, next
					if next_score < score
						break
					++adjustments
					recipe = next
					score = next_score
	_log steps, adjustments
	recipe

show_recipe = ( spec, r )->
	score = get_score spec, r
	cal = get_callories spec, r
	_log r, score, cal
	return

balance_recipe2 = ( spec, cal )->
	score = -1
	recipe = undefined
	for a in [0..100]
		for b in [0..100-a]
			for c in [0..100-a-b]
				d = 100-a-b-c
				r = [a,b,c,d]
				if cal?
					if cal isnt get_callories spec, r
						continue
				s = get_score spec, r
				if score < s
					score = s
					recipe = r
	recipe

try
	spec = parse_spec input
	_log spec
	show_recipe spec, balance_recipe spec
	show_recipe spec, balance_recipe2 spec
	show_recipe spec, balance_recipe2 spec, 500
catch e
	_log e
