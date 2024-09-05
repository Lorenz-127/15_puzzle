extends StaticBody2D

var tile_texture
var tile_name
var real_texture
var tile_size: float = 1.0  # Default size, will be updated

func _ready():
	update_appearance()

func update_appearance():
	if $Sprite2D and tile_texture:
		$Sprite2D.texture = tile_texture
		$Sprite2D.scale = Vector2(tile_size / tile_texture.get_width(), tile_size / tile_texture.get_height())

func set_tile_size(new_size: float):
	tile_size = new_size
	if tile_texture:
		$Sprite2D.texture = tile_texture
		$Sprite2D.scale = Vector2(tile_size / tile_texture.get_width(), tile_size / tile_texture.get_height())
