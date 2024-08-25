extends Area2D

var tiles = []
var solved = []
var tile_scene = preload("res://Scenes/tile.tscn")
var tile_size
var offset
var move_counter = 0
var previous = ""

func _ready():
	start_game()

func start_game():
	tile_size = get_viewport().get_visible_rect().size.x / 4
	var image = Image.load_from_file("res://Assets/img/logo_godot.png")
	var texture = ImageTexture.create_from_image(image)
	var grey_image = Image.load_from_file("res://Assets/img/greytile.png")
	var grey_texture = ImageTexture.create_from_image(grey_image)
	$FullImage.texture = texture
	$FullImage.hide()  # Verstecke das volle Bild zu Beginn

	for j in range(4):
		for i in range(4):
			var region = Rect2i(i * tile_size, j * tile_size, tile_size, tile_size)
			var new_image = image.get_region(region)
			var new_texture = ImageTexture.create_from_image(new_image)
			var new_tile = tile_scene.instantiate()
			new_tile.position = Vector2(tile_size * i + tile_size/2 + i*2, tile_size * j + tile_size/2 + j*2)
			new_tile.tile_name = "Tile" + str(j * 4 + i + 1)
			if new_tile.tile_name == "Tile16":
				new_tile.tile_texture = grey_texture
				new_tile.real_texture = new_texture
			else:
				new_tile.tile_texture = new_texture
			add_child(new_tile)
			tiles.append(new_tile)

	solved = tiles.duplicate()
	shuffle_tiles()
	move_counter = 0

func shuffle_tiles():
	offset = tile_size + 2
	var t = 0
	while t < 100:  # Erhöht für bessere Durchmischung
		var random_tile = tiles[randi() % 16]
		if random_tile.tile_name != "Tile16" and random_tile.tile_name != previous:
			var rows = int(random_tile.position.y / offset)
			var cols = int(random_tile.position.x / offset)
			if check_neighbours(rows, cols):
				t += 1

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var rows = int(mouse_pos.y / offset)
		var cols = int(mouse_pos.x / offset)
		if check_neighbours(rows, cols):
			check_win()

func check_neighbours(rows, cols):
	if rows < 0 or rows > 3 or cols < 0 or cols > 3:
		return false
	
	var pos = rows * 4 + cols
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	for dir in directions:
		var new_pos = tiles[pos].position + dir * offset
		if find_empty(new_pos, pos):
			return true
	
	return false

func find_empty(position, pos):
	var new_rows = int(position.y / offset)
	var new_cols = int(position.x / offset)
	if new_rows < 0 or new_rows > 3 or new_cols < 0 or new_cols > 3:
		return false
	
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos].tile_name == "Tile16" and tiles[new_pos].tile_name != previous:
		swap_tiles(pos, new_pos)
		return true
	return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
	move_counter += 1
	previous = tiles[tile_dst].tile_name

func check_win():
	if tiles == solved and move_counter > 1:
		print("You win in ", move_counter, " moves!!")
		$FullImage.show()
		# Hier können Sie weitere Aktionen für den Gewinn hinzufügen, 
		# z.B. ein Gewinn-Panel anzeigen oder einen Neustart-Button einblenden
