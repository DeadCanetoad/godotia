extends Sprite

class_name Structure

const ACCEL = 9.8

enum StructType { Building, Resource }
enum states { STATIC, FALLING, WITH_ENEMY, WITH_PLAYER }

export(StructType) var structType = StructType.Building
export var title: String
export var description: String

var body
var shape
var velocity = Vector2(0, 0)
var energy = 100
var population = 1000
var state = states.STATIC

func _ready():
	body = $KinematicBody2D
	shape = $KinematicBody2D/CollisionShape2D


func _physics_process(delta):
	if state == states.FALLING:
		velocity.y += delta * ACCEL
		var collision = body.move_and_collide(velocity * delta)
		if collision:
			velocity.y = 0
			state = states.STATIC
