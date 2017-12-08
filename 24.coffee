_log = require 'ololog'
{permute} = require './util'

input = '''
1
3
5
11
13
17
19
23
29
31
41
43
47
53
59
61
67
71
73
79
83
89
97
101
103
107
109
113
'''.split('\n').map (a)->+a


sum = ( vals )->
	out = 0
	for v in vals
		out += v
	out

mul = ( vals )->
	out = 1
	for v in vals
		out *= v
	out

dump = 0
find_optimal_split3_q = ( vs )->
	vs.sort (a,b)->b-a
	goal = sum(vs)/3
	_log 'goal', goal

	#
	# 1. permute main group
	#

	min_len = Infinity
	min_q = Infinity
	cur_len = 0
	permute.minmax_of 1, vs.length//3, vs, ( p )->
		if cur_len isnt p.length
			_log.darkGray 'len', cur_len=p.length

		if cur_len > min_len
			return yes # no need to search deeper -> stop permutation.

		unless goal is sum p
			return

		q = mul p
		unless q < min_q
			return
		_log.yellow p, 'q', q

		#
		# 2. get remaining pkgs
		#
		rem = (v for v in vs when v not in p).sort (a,b)->a-b
		_log '1:', p.join(','), rem.join ','

		#
		# 3. permute 2nd group
		#
		cur_len2 = 0
		found_2nd = permute.minmax_of 1, rem.length//2, rem, ( p2 )->
			if cur_len2 isnt p2.length
				_log.darkGray 'len2', cur_len2 = p2.length
			s = sum p2
			switch
				when s is goal
					_log.green '2:', p2.join ','
					return yes
				when s < goal
					d = goal-s
					if d in rem and d not in p2
						_log.green '2!', d, p2.join ','
						_log.darkGray d + sum p2
						return yes
			return

		if found_2nd
			min_q = q
			min_len = cur_len
			_log.green p, q
		else
			_log.red '2nd split not found'
		return

	_log min_len, min_q
	min_q


sub = ( a, b )->
	v for v in a when v not in b

find_split = ( n, vs )->
	goal = sum(vs)/n
	_log 'find', n, goal
	len = 0
	permute.minmax_of 1, vs.length//n, vs, (p)->
		if len < p.length
			_log.darkGray n, 'len', len = p.length
		s = sum p
		switch
			when s is goal
				# found split of cur_len
				_log.darkGray "#{n}: #{s}=", p
				out = n <= 2 or find_split n-1, sub vs, p
			when s < goal
				d = goal - s
				if d in vs and d not in p
					# found split of cur_len+1
					pp = p.concat [d]
					_log.darkGray "#{n}! #{s+d}=", pp
					out = n <= 2 or find_split n-1, sub vs, pp
		out

find_optimal_split_q = ( n, vs )->
	vs.sort (a,b)->b-a
	goal = sum(vs)/n
	_log 'goal', goal

	#
	# 1. permute main group
	#

	min_len = Infinity
	min_q = Infinity
	cur_len = 0
	permute.minmax_of 1, vs.length//n, vs, ( p )->
		if cur_len isnt p.length
			_log.darkGray n, 'len', cur_len=p.length

		if cur_len > min_len
			return yes # no need to search deeper -> stop permutation.

		unless goal is sum p
			return

		q = mul p
		unless q < min_q
			return
		_log p, 'q', q

		#
		# 2. get remaining pkgs
		#
		rem = sub(vs, p).sort (a,b)->a-b

		#
		# 3. permute 2nd group
		#

		if find_split n-1, rem
			min_q = q
			min_len = cur_len
			_log.green p, q
		else
			_log.red '2nd split not found'
		return

	_log 'len', min_len, 'q', min_q
	min_q
try
	t = Date.now()
	_log.yellow find_optimal_split3_q input
	_log.red Date.now()-t

	t = Date.now()
	_log.yellow find_optimal_split_q 3, input
	_log.red Date.now()-t

	t = Date.now()
	_log.yellow find_optimal_split_q 4, input
	_log.red Date.now()-t


catch e
	_log.red e
