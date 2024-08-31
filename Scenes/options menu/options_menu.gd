class_name OptionsMenu
extends Control


@onready var back_btn = $MarginContainer/VBoxContainer/back_to_main_btn as Button

signal back_to_main_btn


func _ready():
	back_btn.button_down.connect(on_back_to_main_pressed)
	set_process(false)
	
	
func on_back_to_main_pressed() -> void:
	back_to_main_btn.emit()
	set_process(false)
