_log = console.log.bind console
crypto = require 'crypto'

input = 'bgvyzdsv'

mine = ( pass, len = 5 )->
	i = 1
	zeroes = Array(len+1).join '0'
	while yes
		val = "#{pass}#{i}"
		hash = crypto.createHash('md5').update(val).digest 'hex'
		if hash[...len] is zeroes
			_log hash, val
			return i
		i++
	return

_log mine input
_log mine input, 6
