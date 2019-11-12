extends Node2D

signal score_increase

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.type == global.ENTITY_TYPES.COLLECTIBLE:
			child.connect("score_increase", self, "_on_score_increase")
		elif child.type == global.ENTITY_TYPES.NOTHING:
			child.connect("body_entered", $Bouncy, "fall", [child.global_position])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_score_increase(score):
	emit_signal("score_increase", score)