extends Control

signal settings_closed

@onready var back_btn = $SettingsContainer/MarginContainer/VBoxContainer/BackBtn

func _ready():
	connect_signals()

func connect_signals():
	back_btn.pressed.connect(on_back_btn_pressed)

func on_back_btn_pressed():
	settings_closed.emit()  # Use the new syntax to emit the signal
	queue_free()  # Remove the settings scene
