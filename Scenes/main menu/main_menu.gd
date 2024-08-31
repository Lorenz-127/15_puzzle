class_name MainMenu
extends Control


@onready var play_btn = $MarginContainer/HBoxContainer/VBoxContainer/play_btn as Button
@onready var option_btn = $MarginContainer/HBoxContainer/VBoxContainer/option_btn as Button
@onready var profile_btn = $MarginContainer/HBoxContainer/VBoxContainer/profile_btn as Button
@onready var tutorial_btn = $MarginContainer/HBoxContainer/VBoxContainer/tutorial_btn as Button
@onready var exit_btn = $MarginContainer/HBoxContainer/VBoxContainer/exit_btn as Button

@onready var start_level = preload("res://Scenes/game/game.tscn") as PackedScene


func _ready():
	play_btn.button_down.connect(on_play_presed)
	exit_btn.button_down.connect(on_exit_pressed)
	


func on_play_presed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
	
