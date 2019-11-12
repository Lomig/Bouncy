extends Node2D

signal score_increase

const type = global.ENTITY_TYPES.COLLECTIBLE
const SCORE = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	_preload_textures()
	
	
func _preload_textures():
  var textures = [ preload('res://Sprites/Collectibles/Gem1.png'), preload('res://Sprites/Collectibles/Gem2.png'), preload('res://Sprites/Collectibles/Gem3.png')]
  var random_texture = int( rand_range(0, textures.size() ) )
  $Sprite.texture = textures[random_texture]


func _on_Gem_entered(body):
	if visible:
		emit_signal("score_increase", SCORE)
