extends Area2D

signal move_made(moves)
signal puzzle_solved

# Load textures
var image_texture = load("res://Assets/img/logo_godot.png")
var grey_texture = load("res://Assets/img/greytile.png")

var tiles = []
var solved = []
var tile_scene = preload("res://Scenes/game/tile.tscn")
var tile_size: int
var grid_size: int = 4  # Default grid size
var offset: int
var move_counter: int = 0
var previous: String = ""

func _ready():
	start_game()

func start_game(new_grid_size: int = 4):
	grid_size = new_grid_size
	clear_grid()
	create_tiles()
	shuffle_tiles()

func reset_game():
	clear_grid()
	move_counter = 0
	emit_signal("move_made", move_counter)
	create_tiles()
	shuffle_tiles()

func create_tiles():
	clear_grid()
	var viewport_size = get_viewport().get_visible_rect().size
	tile_size = min(viewport_size.x, viewport_size.y) / grid_size  # Verwende grid_size, nicht grid_size + 1
	
	# Center the puzzle
	var start_x = (viewport_size.x - (tile_size * grid_size)) / 2
	var start_y = (viewport_size.y - (tile_size * grid_size)) / 2

	if not image_texture or not grey_texture:
		push_error("Failed to load textures")
		return

	var image = image_texture.get_image()
	if not image:
		push_error("Failed to get image data from logo texture")
		return

	$FullImage.texture = image_texture
	$FullImage.hide()
	
	# Scale grey texture to match tile size
	var scaled_grey_image = grey_texture.get_image()
	scaled_grey_image.resize(tile_size, tile_size)
	var scaled_grey_texture = ImageTexture.create_from_image(scaled_grey_image)
	
	# Create tiles
	for j in range(grid_size):
		for i in range(grid_size):
			var region = Rect2i(i * (image.get_width() / grid_size), j * (image.get_height() / grid_size), 
								image.get_width() / grid_size, image.get_height() / grid_size)
			var new_image = image.get_region(region)
			var new_texture = ImageTexture.create_from_image(new_image)
			var new_tile = tile_scene.instantiate()
			new_tile.position = Vector2(start_x + tile_size * i + tile_size/2, start_y + tile_size * j + tile_size/2)
			new_tile.tile_name = "Tile%d" % (j * grid_size + i + 1)
			new_tile.tile_texture = scaled_grey_texture if new_tile.tile_name == "Tile%d" % (grid_size * grid_size) else new_texture
			new_tile.real_texture = new_texture if new_tile.tile_name == "Tile%d" % (grid_size * grid_size) else null
			
			new_tile.set_tile_size(tile_size)
			
			add_child(new_tile)
			tiles.append(new_tile)
	
	# Add visual grid lines
	var grid_lines = Node2D.new()
	grid_lines.name = "GridLines"
	add_child(grid_lines)

	for i in range(grid_size + 1):
		# Horizontale Linie
		var h_line = Line2D.new()
		h_line.add_point(Vector2(start_x, start_y + i * tile_size))
		h_line.add_point(Vector2(start_x + grid_size * tile_size, start_y + i * tile_size))
		h_line.width = 2
		h_line.default_color = Color.BLACK
		grid_lines.add_child(h_line)

		# Vertikale Linie
		var v_line = Line2D.new()
		v_line.add_point(Vector2(start_x + i * tile_size, start_y))
		v_line.add_point(Vector2(start_x + i * tile_size, start_y + grid_size * tile_size))
		v_line.width = 2
		v_line.default_color = Color.BLACK
		grid_lines.add_child(v_line)
	
	solved = tiles.duplicate()

func clear_grid():
	# Free all existing tiles
	for tile in tiles:
		tile.queue_free()
	tiles.clear()
	solved.clear()

	# Remove existing grid lines
	var existing_grid_lines = get_node_or_null("GridLines")
	if existing_grid_lines:
		existing_grid_lines.queue_free()

func shuffle_tiles():
	var shuffle_count = grid_size * grid_size * 3
	for i in range(shuffle_count):
		var empty_pos = find_empty_tile()
		var valid_moves = []
		for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			var new_pos = empty_pos + dir
			if is_valid_position(new_pos):
				valid_moves.append(new_pos)
		if valid_moves.size() > 0:
			var move_pos = valid_moves[randi() % valid_moves.size()]
			swap_tiles(get_tile_index(move_pos), get_tile_index(empty_pos))
	move_counter = 0

func find_empty_tile() -> Vector2:
	for i in range(tiles.size()):
		if tiles[i].tile_name == "Tile%d" % (grid_size * grid_size):
			return Vector2(i % grid_size, i / grid_size)
	return Vector2.ZERO  # Should never happen

func is_valid_position(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < grid_size and pos.y >= 0 and pos.y < grid_size

func get_tile_index(pos: Vector2) -> int:
	return int(pos.y) * grid_size + int(pos.x)

func check_neighbours(row, col):
	if row < 0 or row >= grid_size or col < 0 or col >= grid_size:
		return false
	
	var pos = row * grid_size + col
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	for dir in directions:
		var new_pos = Vector2(col, row) + dir
		if is_valid_position(new_pos):
			var new_index = get_tile_index(new_pos)
			if tiles[new_index].tile_name == "Tile%d" % (grid_size * grid_size):
				swap_tiles(pos, new_index)
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
		if tiles[i].position != solved[i].position:
			return  # Puzzle not solved
	
	print("You win in ", move_counter, " moves!!")
	$FullImage.show()
	emit_signal("puzzle_solved")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var viewport_size = get_viewport().get_visible_rect().size
		var start_x = (viewport_size.x - (tile_size * grid_size)) / 2
		var start_y = (viewport_size.y - (tile_size * grid_size)) / 2
		var local_mouse_pos = get_local_mouse_position() - Vector2(start_x, start_y)
		var row = int(local_mouse_pos.y / tile_size)
		var col = int(local_mouse_pos.x / tile_size)
		if row >= 0 and row < grid_size and col >= 0 and col < grid_size:
			if check_neighbours(row, col):
				check_win()
