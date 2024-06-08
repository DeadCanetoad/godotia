extends MarginContainer

class_name Statistics

signal game_over

var lives : set = _lives
var health : set = _health
var level : set = _level
var score : set = _score
var hscore = 0
var population : set = _population
var time : set = _time
var energy : set = _energy
var max_energy = 0
var nodes

func _ready():
	nodes = {
		lives = $HBox/Left/Lives,
		health = $HBox/Left/Health,
		level = $HBox/Left/Level,
		score = $HBox/Left/Score,
		hscore = $HBox/Left/HScore,
		population = $HBox/Right/Pop,
		time = $HBox/Right/Time,
		energy = $HBox/Right/Energy
	}


func reset():
	_lives(3)
	_health(100)
	_level(1)
	_score(0)
	_time(0)
	start_clock()
	update()


func update():
	var status = globals.get_status()
	_population(status.p)
	_energy(status.e)


func _lives(n):
	lives = n
	var i = 0
	for node in nodes.lives.get_children():
		node.visible = i < n
		i += 1


func _health(n):
	health = n
	nodes.health.value = n


func _level(n):
	level = n
	nodes.level.text = "Level: %d" % n


func _score(n):
	score = n
	nodes.score.text = "Score: %05d" % n
	if score > hscore:
		hscore = score
	nodes.hscore.text = "HScore: %05d" % hscore


func _population(n):
	population = n
	nodes.population.text = "Population: %d" % n
	if n < 1:
		emit_signal("game_over")


func _time(n):
	time = n
	nodes.time.text = "Survival time: %02d:%02d" % [n / 60, n % 60]


func _energy(n):
	if n > max_energy:
		max_energy = n
	energy = n * 100 / max_energy
	nodes.energy.value = energy


func _on_Clock_timeout():
	self.time += 1


func start_clock():
	_time(0)
	$Clock.start()


func stop_clock():
	$Clock.stop()


func add_points(points):
	self.score += points


func reduce_health():
	self.health -= 1
	return health


func lose_life():
	self.lives -= 1
	return lives
