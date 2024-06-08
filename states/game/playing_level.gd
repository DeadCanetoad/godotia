extends Node

var fsm: StateMachine
var g
var connect = true

func enter():
	g = globals.game
	g.spawn_enemy()
	if connect:
		connect = g.map.connect("end_of_level", Callable(self, "increase_level"))
		connect = g.stats.connect("game_over", Callable(self, "game_over"))
		connect = g.player.connect("killed", Callable(self, "game_over"))


func increase_level():
	fsm.change_to("end_of_level")


func game_over():
	fsm.change_to("game_over")


func process(delta):
	globals.game.stats.update()
	g.move_background(g.speed * delta)
	g.map.position_player(g.player, g.scroll_position, g.terrain)
	g.map.update_all_entities(g.scroll_position)
	process_inputs(delta)
	if g.stats.lives < 0:
		game_over()


func process_inputs(delta):
	if Input.is_action_pressed("ui_left"):
		g.speed = clamp(g.speed + g.THRUST * delta, -g.MAX_SPEED, g.MAX_SPEED)
	if Input.is_action_pressed("ui_right"):
		g.speed = clamp(g.speed - g.THRUST * delta, -g.MAX_SPEED, g.MAX_SPEED)
	if Input.is_action_pressed("ui_up") and g.player.position.y > g.TOP_LEVEL:
		g.player.move(0, -delta)
	if Input.is_action_pressed("ui_down") and g.player.position.y < g.terrain.base_level:
		g.player.move(0, delta)
	if Input.is_action_just_pressed("ui_accept"):
		if randf() > 0.6:
			g.fire_missile()
		else:
			g.fire_beam()
