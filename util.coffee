
exports.log = exports._log = _log = require 'ololog'

#
# fast array permutation
#
permute = exports.permute = ( arr, cb )->
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

n_of = permute.n_of = ( n, arr, cb, args=[] )->
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

minmax_of = permute.minmax_of = ( min, max, arr, cb )->
	for i in [min..max]
		n_of i, arr, cb
	return

