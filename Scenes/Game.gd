extends Node

var score = 0

func _ready():
	for child in get_children():
		child.connect("score_increase", self, "_on_score_increase")

func _on_score_increase(score_gain):
	score += score_gain