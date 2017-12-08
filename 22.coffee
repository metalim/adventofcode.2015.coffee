_log = require 'ololog'

input = '''
Hit Points: 58
Damage: 9
'''

apply_effects = ( state )->
	state.p.def = 0
	ne = {}
	for k, v of state.p.e ? {}
		state.b.hp -= v.a if v.a?
		state.p.def += v.def if v.def?
		state.p.mp += v.mp if v.mp?
		if --v.len > 0
			ne[k] = v
	state.p.e = ne
	state.b.hp <= 0


cast = ( state, sp )->
	if state.p.mp < sp.c
		return no

	if sp.e? and state.p.e[sp.i]?
		return no

	state.p.mp -= sp.c
	state.p.c += sp.c
	state.b.hp -= sp.a if sp.a?
	state.p.hp += sp.hp if sp.hp?
	if sp.e?
		state.p.e[sp.i] = Object.assign {}, sp.e
	yes

last_dump = undefined
dumped = 0
dump = ( label, state, track )->
	if track? and state.id is track[...state.id.length]
		json = JSON.stringify state
		if last_dump is json
			_log label, 'unchanged'
		else
			if ++dumped%2
				_log.yellow label, state
			else
				_log.lightYellow label, state
			last_dump = json
	return

find_min_mana_to_win = ( state, sps, hard, track )->
	next = [JSON.stringify state]

	min = Infinity
	min_id = ''
	while next.length > 0
		#_log.darkGray 'spread', next.length
		last = next
		next = []
		for json in last

			state = JSON.parse json

			if hard and --state.p.hp <= 0
				continue

			dump 'init', state, track

			#
			# 0. check if fight can become leader in cost-efficiency
			#
			unless state.p.c < min
				continue

			#
			# 1. apply effects for player's turn
			#
			if apply_effects state
				dump 'effect 1: win', state, track
				min = state.p.c
				min_id = state.id
				_log.yellow min, min_id
				continue
			dump 'effect 1', state, track

			# 2. save, as it will get loaded for each spell
			json = JSON.stringify state

			#
			# 3. fight
			#
			for sp in sps
				state = JSON.parse json
				state.id += sp.i

				#
				# 3.1 Player's turn: cast a spell
				#
				unless cast( state, sp ) and state.p.c < min
					continue

				# 3.2 check for dead boss
				if state.b.hp <= 0
					dump 'cast: win', state, track
					min = state.p.c
					min_id = state.id
					_log.cyan min, min_id
					continue

				dump 'cast', state, track

				# 3.3 apply effects for boss's turn
				if apply_effects state
					dump 'effect 2: win', state, track
					min = state.p.c
					min_id = state.id
					_log.red min, min_id
					continue

				dump 'effect 2', state, track

				# 3.4 Boss' turn
				if (state.p.hp -= state.b.a - state.p.def) <= 0
					continue

				dump 'def', state, track

				# 3.5 save
				next.push JSON.stringify state
	_log 'best id', min_id
	min

do ->
	try
		boss =
			hp: 58
			a: 9

		player =
			hp: 50
			mp: 500
			def: 0
			e: {}
			c: 0

		spells = [
			{
				c: 53
				a: 4
				i: 0
			}
			{
				c: 73
				a: 2
				hp: 2
				i: 1
			}
			{
				c: 113
				i: 2
				e:
					len: 6
					def: 7
			}
			{
				c: 173
				i: 3
				e:
					len: 6
					a: 3
			}
			{
				c: 229
				i: 4
				e:
					len: 5
					mp: 101
			}
		]

		state =
			id:''
			p:player
			b:boss

		_log.green find_min_mana_to_win state, spells, no #, '304324310'
		_log.green find_min_mana_to_win state, spells, yes #, '342342300'

	catch e
		_log.red e
	return
