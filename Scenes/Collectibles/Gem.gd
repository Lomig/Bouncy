extends "Collectible.gd"

func _ready():
	._ready()
	_preload_textures()
	item_value["score"] = 15


func _preload_textures():
  var textures = [ preload('res://Sprites/Collectibles/Gem1.png'), preload('res://Sprites/Collectibles/Gem2.png'), preload('res://Sprites/Collectibles/Gem3.png')]
  var random_texture = int( rand_range(0, textures.size() ) )
  $Sprite.texture = textures[random_texture]