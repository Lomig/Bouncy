extends Node2D

var direction
var move_sprite
var reset_sprite

var sprite

func _ready():
	sprite = get_node("Sprite")

func _physics_process(delta):
	if move_sprite:
		if deg2rad(45) - abs(sprite.rotation) < 0:
			move_sprite = false
			reset_sprite = true
		else:
			sprite.rotate(direction * deg2rad(9))
	elif reset_sprite:
		sprite.rotate(- direction * deg2rad(5))
		if abs(sprite.rotation) < deg2rad(1):
			sprite.rotation = 0
			reset_sprite = false

func tilt(dir):
	direction = dir
	move_sprite = true