extends Area2D

var tiles = []
var solved = []
var tile_scene = preload("res://Scenes/game/tile.tscn")
var tile_size
var offset
var move_counter = 0
var previous = ""
signal move_made(moves)
signal puzzle_solved

func _ready():
	start_game()

func start_game():
	# Clear existing tiles
	for tile in tiles:
		tile.queue_free()
	tiles.clear()
	solved.clear()

	# Calculate tile size
	tile_size = get_viewport().get_visible_rect().size.x / 4

	# Load textures
	var image = load("res://Assets/img/logo_godot.png")
	if not image:
		push_error("Failed to load logo image")
		return

	var grey_texture = load("res://Assets/img/greytile.png")
	if not grey_texture:
		push_error("Failed to load grey tile texture")
		return

	# Ensure image is of type Image
	if image is Texture2D:
		image = image.get_image()
	if not image:
		push_error("Failed to get image data from logo texture")
		return

	# Set full image texture
	$FullImage.texture = ImageTexture.create_from_image(image)
	$FullImage.hide()  # Hide the full picture at the beginning

	# Create tiles
	for j in range(4):
		for i in range(4):
			var region = Rect2i(i * tile_size, j * tile_size, tile_size, tile_size)
			var new_image = image.get_region(region)
			var new_texture = ImageTexture.create_from_image(new_image)
			var new_tile = tile_scene.instantiate()
			new_tile.position = Vector2(tile_size * i + tile_size/2 + i*2, tile_size * j + tile_size/2 + j*2)
			new_tile.tile_name = "Tile%d" % (j * 4 + i + 1)
			new_tile.tile_texture = grey_texture if new_tile.tile_name == "Tile16" else new_texture
			new_tile.real_texture = new_texture if new_tile.tile_name == "Tile16" else null
			add_child(new_tile)
			tiles.append(new_tile)

	solved = tiles.duplicate()
	shuffle_tiles()
	move_counter = 0
	emit_signal("move_made", move_counter)

func shuffle_tiles():
	offset = tile_size + 2
	var t = 0
	while t < 4:  # Increased for better mixing
		var random_tile = tiles[randi() % 16]
		if random_tile.tile_name != "Tile16" and random_tile.tile_name != previous:
			var rows = int(random_tile.position.y / offset)
			var cols = int(random_tile.position.x / offset)
			if check_neighbours(rows, cols):
				t += 1

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_mouse_pos = get_local_mouse_position()
		var rows = int(local_mouse_pos.y / offset)
		var cols = int(local_mouse_pos.x / offset)
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
	emit_signal("move_made", move_counter)

func check_win():
	for i in range(tiles.size()):
		if tiles[i].tile_name != solved[i].tile_name:
			return  # Puzzle not solved
	
	print("You win in ", move_counter, " moves!!")
	$FullImage.show()
	emit_signal("puzzle_solved")
		
		# Here you can add further actions for the win, 
		# e.g. display a win panel or show a restart button
