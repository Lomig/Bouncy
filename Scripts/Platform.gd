extends Node2D

var direction
var move_sprite
var reset_sprite

var sprite

func _ready():
	sprite = get_node("Sprite")

func _physics_process(delta):
	if move_sprite:
		if deg2rad(45) - abs(sprite.rotation) < deg2rad(1):
			move_sprite = false
			reset_sprite = true
		else:
			sprite.rotate(direction * deg2rad(9))
	elif reset_sprite:
		if abs(sprite.rotation) < deg2rad(1):
			sprite.rotation = 0
			reset_sprite = false
		else:
			sprite.rotate(- direction * deg2rad(5))

func tilt(dir):
	direction = dir
	move_sprite = true

func reset():
	sprite.rotation = 0
	move_sprite = false
	reset_sprite = false