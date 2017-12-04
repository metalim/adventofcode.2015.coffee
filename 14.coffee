_log = require 'ololog'

input = '''
Rudolph can fly 22 km/s for 8 seconds, but then must rest for 165 seconds.
Cupid can fly 8 km/s for 17 seconds, but then must rest for 114 seconds.
Prancer can fly 18 km/s for 6 seconds, but then must rest for 103 seconds.
Donner can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 11 km/s for 12 seconds, but then must rest for 125 seconds.
Comet can fly 21 km/s for 6 seconds, but then must rest for 121 seconds.
Blitzen can fly 18 km/s for 3 seconds, but then must rest for 50 seconds.
Vixen can fly 20 km/s for 4 seconds, but then must rest for 75 seconds.
Dancer can fly 7 km/s for 20 seconds, but then must rest for 119 seconds.
'''.split '\n'

r_in = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./


class Deer
	constructor: ( str )->
		res = r_in.exec str
		@name = res[1]
		@speed = +res[2]
		@periods = [
			+res[4]
			+res[3]
		]
		@d = 0
		@score = 0
		@flying = 1
		@t = @periods[@flying]
		return

	tick: ->
		if @flying
			@d += @speed
		unless --@t
			@flying = 1 - @flying
			@t = @periods[@flying]
		return

get_leader = ( deers, key )->
	leader = deers[0]
	for d in deers
		if leader[key] < d[key]
			leader = d
	leader

race = ( input, time, score )->
	deers = for s in input
		new Deer s

	for t in [0...time]
		for d in deers
			d.tick() # move
		score deers

	for d in deers
		_log.darkGray d.name, d.score, d.d
	lead = get_leader deers, 'score'
	[lead.name, lead.score]

score_by_distance = ( deers )->
	for d in deers
		d.score = d.d
	return

score_by_lead = ( deers )->
	leader = get_leader deers, 'd'
	for d in deers
		if d.d is leader.d
			d.score++
	return

try
	_log race input, 2503, score_by_distance
	_log race input, 2503, score_by_lead
catch e
	_log e
