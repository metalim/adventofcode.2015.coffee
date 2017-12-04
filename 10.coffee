_log = console.log.bind console

input = '1113122113'
'132113'
'3113'
'1113'
'13'
'3'

say = ( s, times )->
	while times--
		out = ''
		cur = s[0]
		num = 0
		for c in s
			if c is cur
				num++
			else
				out += "#{num}#{cur}"
				num = 1
				cur = c
		out += "#{num}#{cur}"
		s = out
		#_log out.length
	out

_log 40, say(input, 40).length
_log 50, say(input, 50).length

