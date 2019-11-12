extends Node2D

signal collectible_increase

const type = global.ENTITY_TYPES.COLLECTIBLE
var item_value

func _ready():
	item_value = {}
	$Area2D.connect("body_entered", self, "_on_collectible_entered")

func _on_collectible_entered(body):
	if visible:
		emit_signal("collectible_increase", item_value)
	hide()