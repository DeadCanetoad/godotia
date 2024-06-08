extends CharacterBody2D

class_name Structure, "res://textures/structures/aparto.png"

const ACCEL = 20
const CRASH_SPEED = 40

enum states { STATIC, FALLING }

@export var title: String
@export var description: String

var velocity = Vector2(0, 0)
var state = states.STATIC
var targeted = false

func _ready():
	var mat = get_node("Sprite2D").get_material().duplicate(true)
	get_node("Sprite2D").set_material(mat)


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = move_and_collide(velocity * delta)
		if collision:
			if velocity.y >= CRASH_SPEED:
				globals.output("Structure crash speed: %s" % velocity.y)
				destroy()
			velocity.y = 0
			state = states.STATIC
		if position.y > 0 and velocity.y > 1:
			globals.output("Structure hit ground")
			destroy()


func destroy():
	state = states.STATIC
	$AnimationPlayer.play("Explosion")
	$Splat.play()


func reparent(dest: Node, pos: Vector2):
	if get_parent() != dest:
		globals.output("Reparent: %s to %s" % [get_parent().get_instance_id(), dest.name])
		get_parent().remove_child(self)
		position = pos
		dest.add_child(self)


func _on_AnimationPlayer_animation_finished(_anim_name):
	visible = false
