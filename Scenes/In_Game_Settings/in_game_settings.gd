extends Control

signal settings_closed
signal puzzle_size_changed(new_size)

@onready var back_btn = $SettingsContainer/MarginContainer/VBoxContainer/BackBtn
@onready var size_slider = $SettingsContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/SizeSlider
@onready var size_value = $SettingsContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/SizeValue
@onready var change_image_btn = $SettingsContainer/MarginContainer/VBoxContainer/ChangeImageBtn

var image_option_button
var image_selection_dialog

func _ready():
	connect_signals()
	initialize_size_slider()
	setup_image_selection_dialog()
	change_image_btn.pressed.connect(on_change_image_pressed)
	image_selection_dialog.confirmed.connect(_on_image_selection_dialog_confirmed)

func connect_signals():
	back_btn.pressed.connect(on_back_btn_pressed)
	size_slider.value_changed.connect(on_size_slider_changed)
	change_image_btn.pressed.connect(on_change_image_pressed)

func setup_image_selection_dialog():
	image_selection_dialog = ConfirmationDialog.new()
	image_selection_dialog.title = "Select Puzzle Image"
	
	image_option_button = OptionButton.new()
	image_selection_dialog.add_child(image_option_button)
	
	add_child(image_selection_dialog)
	populate_image_options()

func on_change_image_pressed():
	image_selection_dialog.popup_centered()

func populate_image_options():
	image_option_button.clear()
	var all_images = ImageManager.get_all_images()
	for i in range(all_images.size()):
		var image = all_images[i]
		image_option_button.add_item(image.name, i)

func _on_image_selection_dialog_confirmed():
	var selected_index = image_option_button.get_selected_id()
	var selected_image = ImageManager.get_all_images()[selected_index]
	ImageManager.switch_to_user_image(selected_image.id)

func on_back_btn_pressed():
	settings_closed.emit()  # Use the new syntax to emit the signal
	queue_free()  # Remove the settings scene

func initialize_size_slider():
	# Ensure the slider is set up correctly
	size_slider.min_value = 3
	size_slider.max_value = 8
	size_slider.value = 4  # Default value
	size_value.text = str(int(size_slider.value))
	
func on_size_slider_changed(value):
	var new_size = int(value)
	size_value.text = str(new_size)
	puzzle_size_changed.emit(new_size)
