extends Node2D

signal collectible_increase

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.type == global.ENTITY_TYPES.COLLECTIBLE:
			child.connect("collectible_increase", self, "_on_collectible_increase")
		elif child.type == global.ENTITY_TYPES.NOTHING:
			child.connect("body_entered", $Bouncy, "fall", [child.global_position])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_collectible_increase(collectible):
	emit_signal("collectible_increase", collectible)