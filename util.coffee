
exports.log = exports._log = _log = require 'ololog'

#
# fast array permutation
#
exports.permute = ( arr, cb )->
	permutation = arr[..]
	length = permutation.length
	c = new Array(length).fill 0
	i = 1
	result = [permutation[..]] unless cb?
	#k, p;

	while i < length
		if c[i] < i
			k = i % 2 and c[i]
			p = permutation[i]
			permutation[i] = permutation[k]
			permutation[k] = p
			++c[i]
			i = 1
			if cb?
				return if no is cb permutation
			else
				result.push permutation[..]
		else
			c[i] = 0
			++i
	result unless cb?

n_of = exports.permute.n_of = ( n, arr, cb, args=[] )->
	# if n > arr.length
	# 	throw new Error "array[#{arr.length}] is smaller than #{n}"
	if n<1
		cb []
		return
	for el, i in arr
		if n>1
			next = arr[...i].concat arr[i+1..]
			n_of n-1, next, cb, args.concat [el]
		else
			cb args.concat [el]
	return

minmax_of = exports.permute.minmax_of = ( min, max, arr, cb )->
	for i in [min..max]
		n_of i, arr, cb
	return

# exports.permute_spec = ( spec, cb )->
# 	mutes = for def in spec
# 		switch
# 			when 

# 	_perm = (m, cb, args=[])->
# 		if m[0]?
# 			next = m[1..]
# 			m[0] (a)->_perm m

# 	_perm mutes, cb
