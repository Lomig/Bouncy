extends Node

var score = 0
var vial = 0
var axe = 0
var helmet = 0
var life = 2


func _ready():
	for child in get_children():
		child.connect("collectible_increase", self, "_on_collectible_increase")


func _on_collectible_increase(collectible):
	score += collectible.get("score", 0)
	vial += collectible.get("vial", 0)
	axe += collectible.get("axe", 0)
	helmet += collectible.get("helmet", 0)
	life += collectible.get("life", 0)
	print("⌜⌜⌜┌-------------┐")
	print("|  score: %3d |" % score)
	print("|   vial: %3d |" % vial)
	print("|    axe: %3d |" % axe)
	print("| helmet: %3d |" % helmet)
	print("|   life: %3d |" % life)
	print("└-------------┘\n")