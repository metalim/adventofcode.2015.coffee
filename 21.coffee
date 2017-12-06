_log = require 'ololog'
{permute} = require './util'

boss_spec = '''
Hit Points: 103
Damage: 9
Armor: 2
'''

shop_spec = '''
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
'''

fight = ( player, boss )->
	pa = Math.max 1, player.dmg - boss.def
	ba = Math.max 1, boss.dmg - player.def
	hp = player.hp
	bhp = boss.hp
	step = 0
	#_log step, hp, bhp
	while hp>0 and bhp>0
		if ++step%2
			bhp -= pa
		else
			hp -= ba
		#_log step, hp, bhp
	hp>0

equip = ( pl, eq )->
	pl.hp = 100
	pl.cost = 0
	pl.dmg = 0
	pl.def = 0
	for it in eq
		pl.cost += it[0]
		pl.dmg += it[1]
		pl.def += it[2]
	pl.cost

find_min_gold_to_win = ( shop, boss )->
	min = Infinity
	player = {}
	permute.n_of 1, shop.weapons, (w)->
		permute.minmax_of 0,1, shop.armors, (a)->
			permute.minmax_of 0,2, shop.rings, (r)->
				cost = equip player, cfg = w.concat a.concat r
				if cost < min and fight player, boss
					_log.yellow cost, cfg
					min = cost
	min

find_max_gold_to_lose = ( shop, boss )->
	max = 0
	player = {}
	permute.n_of 1, shop.weapons, (w)->
		permute.minmax_of 0,1, shop.armors, (a)->
			permute.minmax_of 0,2, shop.rings, (r)->
				cost = equip player, cfg = w.concat a.concat r
				if cost > max and not fight player, boss
					_log.yellow cost, cfg
					max = cost
	max

do ->
	try
		boss =
			hp: 103
			dmg: 9
			def: 2
		test =
			hp:100
			dmg:9
			def:0
		#_log.cyan fight test,boss
		shop =
			weapons: [
				[8, 4, 0]
				[10, 5, 0]
				[25, 6, 0]
				[40, 7, 0]
				[74, 8, 0]
			]
			armors: [
				[13, 0, 1]
				[31, 0, 2]
				[53, 0, 3]
				[75, 0, 4]
				[102, 0, 5]
			]
			rings: [
				[25, 1, 0]
				[50, 2, 0]
				[100, 3, 0]
				[20, 0, 1]
				[40, 0, 2]
				[80, 0, 3]
			]

		_log.green find_min_gold_to_win shop, boss
		_log.green find_max_gold_to_lose shop, boss

	catch e
		_log.red e
