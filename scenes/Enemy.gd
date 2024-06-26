extends Area2D

class_name Enemy

signal enemy_killed(points)

const SPEED = 100
const RATE_OF_DRAINING_ENERGY = 100
const POINTS = 10
const BONUS_POINTS = 50

var target = {}
var payload : Structure
var shot_scene = preload("res://scenes/Shot.tscn")
var shot_range_squared : float
var body_entered
var area_entered
var anim

func _ready():
	shot_range_squared = pow(randf_range(globals.shots.range1, globals.shots.range2), 2)
	for node in $States.get_children():
		node.e = self
	anim = $AnimationPlayer
	# Make shader material unique
	# https://godotengine.org/qa/2866/how-do-i-make-material-shader-instances-2d
	var mat = get_node("Sprite2D").get_material().duplicate(true)
	get_node("Sprite2D").set_material(mat)


func move(delta):
	position = position.move_toward(target.position, SPEED * delta)


func _on_Enemy_area_entered(area):
	# Got hit by player or a missile
	area_entered = area


func _on_Enemy_body_entered(body):
	if body is Structure:
		body_entered = body


func fire():
	if $ShotTimer.is_stopped():
		var shot = shot_scene.instantiate()
		shot.position = position
		shot.direction = (target.position - position).normalized()
		get_parent().add_child(shot)
		get_node("Fire").play()
		$ShotTimer.start(randf_range(globals.shots.fire_delay1, globals.shots.fire_delay2))


func got_building():
	globals.output("Got_building")


func emit_killed(points):
	emit_signal("enemy_killed", points)


func become_idle():
	$States.change_to("enemy_idle")
