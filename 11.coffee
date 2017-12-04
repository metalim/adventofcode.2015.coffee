_log = console.log.bind console

input = 'vzbxkghb'

alpha = 'abcdefghijklmnopqrstuvwxyz'
CHARS = 'abcdefghjkmnpqrstuvwxyz'
BASE = CHARS.length
CODES = {}
CODES[c] = i for c, i in CHARS

decode = ( pwd )->
	pwd.split('').map (c)->CODES[c]

encode = ( codes )->
	codes.map (i)->CHARS[i]
	.join ''

is_valid = ( pwd )->
	straight = no
	pairs = {}
	for c, i in pwd
		straight = yes if c+1 is pwd[i+1] and pwd[i+1]+1 is pwd[i+2]
		pairs[c]=1 if c is pwd[i+1]
	straight and Object.keys(pairs).length>=2

inc = ( pwd )->
	for i in [pwd.length-1..0]
		if pwd[i]<BASE-1
			pwd[i]++
			return
		else
			pwd[i]=0
	throw new Error 'overflow'
	return

next_pwd = ( pwd )->
	codes = decode pwd
	i = 0
	while yes
		inc codes
		++i
		_log i unless i%100
		break if is_valid codes
	encode codes

_log input, decode input

_log (pwd = next_pwd input), decode pwd
_log (pwd = next_pwd pwd), decode pwd
