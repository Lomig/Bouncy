extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_EmptySpace_body_entered(body):
	if body.name == "Bouncy":
		body.fall(global_position.x)
