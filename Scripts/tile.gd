extends StaticBody2D

var tile_texture
var tile_name
var real_texture

func _ready():
	$Sprite2D.texture = tile_texture
