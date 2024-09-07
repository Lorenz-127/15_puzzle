extends Node

signal image_changed(texture)

var config = ConfigFile.new()
var current_image_path: String = "res://Assets/img/logo_godot.png"
var current_texture: Texture2D

var predefined_images = [
	{"id": "default", "name": "Godot Logo", "path": "res://Assets/img/logo_godot.png"},
	{"id": "image1", "name": "Kali", "path": "res://Assets/img/kali_2.jpeg"},
	{"id": "image2", "name": "Lorenz", "path": "res://Assets/img/lorenz_06-24.jpeg"},
]

func _ready():
	load_metadata()
	load_current_image()

func load_metadata():
	var err = config.load("user://image_metadata.cfg")
	if err == OK:
		current_image_path = config.get_value("general", "current_image_path", current_image_path)
	else:
		# If the file doesn't exist, we'll create it when we save
		save_metadata()

func save_metadata():
	config.set_value("general", "current_image_path", current_image_path)
	config.save("user://image_metadata.cfg")

func load_current_image():
	current_texture = load(current_image_path)
	emit_signal("image_changed", current_texture)

func set_image(path: String):
	if FileAccess.file_exists(path):
		current_image_path = path
		save_metadata()
		load_current_image()
	else:
		push_error("Image file not found: " + path)

func add_user_image(id: String, name: String, path: String):
	config.set_value("image_" + id, "id", id)
	config.set_value("image_" + id, "name", name)
	config.set_value("image_" + id, "path", path)
	save_metadata()

func get_all_images() -> Array:
	var all_images = predefined_images.duplicate()
	for section in config.get_sections():
		if section.begins_with("image_"):
			all_images.append({
				"id": config.get_value(section, "id"),
				"name": config.get_value(section, "name"),
				"path": config.get_value(section, "path")
			})
	return all_images

func switch_to_image(id: String):
	for image in predefined_images:
		if image.id == id:
			set_image(image.path)
			return
	
	var path = config.get_value("image_" + id, "path", "")
	if path != "":
		set_image(path)
	else:
		push_error("Image with id " + id + " not found")

func switch_to_user_image(id: String):
	for image in predefined_images:
		if image.id == id:
			set_image(image.path)
			return
	
	var path = config.get_value("image_" + id, "path", "")
	if path != "":
		set_image(path)
	else:
		push_error("Image with id " + id + " not found")
