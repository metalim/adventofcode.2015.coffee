_log = require 'ololog'







input = '''
jio a, +18
inc a
tpl a
inc a
tpl a
tpl a
tpl a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
tpl a
tpl a
inc a
jmp +22
tpl a
inc a
tpl a
inc a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
jio a, +8
inc b
jie a, +4
tpl a
inc a
jmp +2
hlf a
jmp -7
'''.split '\n'

exec = ( ops, a )->
	i = 0
	r =
		a:a ? 0
		b:0
	while 0<=i<ops.length
		l = ops[i]
		#_log i, r.a, r.b, l
		switch l[..2]
			when 'hlf'
				r[l[4]] //= 2
			when 'tpl'
				r[l[4]] *= 3
			when 'inc'
				++r[l[4]]
			when 'jmp'
				i += +l[4..] - 1
			when 'jie'
				if r[l[4]]%2 is 0
					i += +l[6..] - 1
			when 'jio'
				if r[l[4]] is 1
					i += +l[6..] - 1
			else
				throw new Error "unknown instruction @#{i}: #{l}"
		++i
	r

try
	_log.yellow exec input
	_log.yellow exec input, 1

catch e
	_log.red e
