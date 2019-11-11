extends Area2D

func _ready():
	pass


func _on_EmptySpace_body_entered(body):
	if body.name == "Bouncy":
		body.fall(global_position)