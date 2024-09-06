extends Control

signal settings_closed
signal puzzle_size_changed(new_size)

@onready var back_btn = $SettingsContainer/MarginContainer/VBoxContainer/BackBtn
@onready var size_slider = $SettingsContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/SizeSlider
@onready var size_value = $SettingsContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/SizeValue


func _ready():
	connect_signals()
	initialize_size_slider()

func connect_signals():
	back_btn.pressed.connect(on_back_btn_pressed)
	size_slider.value_changed.connect(on_size_slider_changed)

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
