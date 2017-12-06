_log = require 'ololog'

input = '''
Al => ThF
Al => ThRnFAr
B => BCa
B => TiB
B => TiRnFAr
Ca => CaCa
Ca => PB
Ca => PRnFAr
Ca => SiRnFYFAr
Ca => SiRnMgAr
Ca => SiTh
F => CaF
F => PMg
F => SiAl
H => CRnAlAr
H => CRnFYFYFAr
H => CRnFYMgAr
H => CRnMgYFAr
H => HCa
H => NRnFYFAr
H => NRnMgAr
H => NTh
H => OB
H => ORnFAr
Mg => BF
Mg => TiMg
N => CRnFAr
N => HSi
O => CRnFYFAr
O => CRnMgAr
O => HP
O => NRnFAr
O => OTi
P => CaP
P => PTi
P => SiRnFAr
Si => CaSi
Th => ThCa
Ti => BP
Ti => TiTi
e => HF
e => NAl
e => OMg
'''.split '\n'

molecule = 'CRnCaSiRnBSiRnFArTiBPTiTiBFArPBCaSiThSiRnTiBPBPMgArCaSiRnTiMgArCaSiThCaSiRnFArRnSiRnFArTiTiBFArCaCaSiRnSiThCaCaSiRnMgArFYSiRnFYCaFArSiThCaSiThPBPTiMgArCaPRnSiAlArPBCaCaSiRnFYSiThCaRnFArArCaCaSiRnPBSiRnFArMgYCaCaCaCaSiThCaCaSiAlArCaCaSiRnPBSiAlArBCaCaCaCaSiThCaPBSiThPBPBCaSiRnFYFArSiThCaSiRnFArBCaCaSiRnFYFArSiThCaPBSiThCaSiRnPMgArRnFArPTiBCaPRnFArCaCaCaCaSiRnCaCaSiRnFYFArFArBCaSiThFArThSiThSiRnTiRnPMgArFArCaSiThCaPBCaSiRnBFArCaCaPRnCaCaPMgArSiRnFYFArCaSiThRnPBPMgAr'

parse = ( input )->
	r_in = /(\w+) => (\w+)/
	rules = {}
	for l in input
		res = r_in.exec l
		rules[res[1]]?=[]
		rules[res[1]].push res[2]
	rules

split_mol = ( mol )->
	mol.match /[A-Z][a-z]*|e/g

####################################################

get_stat = ( rules, mol )->
	alph = e:id:0
	next_id = 1
	for a in split_mol mol
		alph[a]?={}
		alph[a].id ?= next_id++
		alph[a].dest = no
		alph[a].src = no
		alph[a].req = yes
	for k, v of rules
		alph[k]?={}
		alph[k].id ?= next_id++
		alph[k].dest ?= no
		alph[k].src = yes
		for m in v
			for a in split_mol m
				alph[a]?={}
				alph[a].id ?= next_id++
				alph[a].dest = yes
				alph[a].src ?= no
	alph

translate = ( stat, rules, mol )->
	map = {}
	root = '0'.charCodeAt()
	leaf = 'a'.charCodeAt()
	mid = 'E'.charCodeAt()
	for k, v of stat
		map[k] = String.fromCharCode switch
			when not v.dest
				root++
			when not v.src
				leaf++
			else
				mid++

	_log.darkGray map

	nmol = (for a in split_mol mol
		map[a]
	).join ''

	nr = {}
	for k,v of rules
		nr[map[k]] = (
			for m in v
				(map[a] for a in split_mol m).join ''
			)

	[nr,nmol]

############################################

mutate = ( rules, mol )->
	res = {}
	for at, i in mol
		l = mol[...i]
		r = mol[i+1..]
		for at2 in rules[at] ? []
			res[l+at2+r]=1
	Object.keys res


visited = {}
dump = 0
bruteforce = ( rules, start, end )->
	steps = Infinity
	unless visited[start]
		visited[start]=1
		_log start unless dump++%1000
		for next in mutate rules, start
			if next is end
				return 1
			if next.length < end.length
				can = bruteforce rules, next, end
				if steps > can
					steps = can
	steps


unrule = ( rules )->
	unrules = {}
	for k, v of rules
		for a in v
			unrules[a[0]]?={}
			unrules[a[0]][a] = k
	unrules


unmutate = ( unr, mol )->
	res = []
	set = {}
	for a, i in mol
		if unr[a]?
			l = mol[...i]
			for k, b of unr[a] when k is mol[i...i+k.length]
				r = mol[i+k.length..]
				next = l+b+r
				if not set[next]
					res.push next
					set[next]=1
	res.sort (a,b)->a.length-b.length # this does the trick!!! shorter first.

visited = {}
unbrute = ( unr, start, end, limit = Infinity, depth = 0 )->
	if visited[start]
		if visited[start] > depth
			visited[start] = depth
		Infinity
	else
		visited[start] = depth
		_log.darkGray depth, start unless dump++%100000
		for next in unmutate unr, start
			if next is end
				_log.green '! found at step', depth+1, dump
				steps = depth+1
				break
			if depth < limit
				can = unbrute unr, next, end, limit, depth+1
				if steps > can
					steps = can
		steps

try
	rules = parse input
	stat = get_stat rules, molecule
	[rules,molecule] = translate stat, rules, molecule

	out = mutate rules, molecule
	_log out.length

	# will not complete in a lifetime.
	#_log bruteforce rules, '0', molecule

	_log.darkGray unrules = unrule rules
	_log unbrute unrules, molecule, '0'

catch e
	_log.red e
