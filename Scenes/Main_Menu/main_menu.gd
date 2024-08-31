class_name MainMenu
extends Control


@onready var play_btn = $MarginContainer/HBoxContainer/VBoxContainer/play_btn as Button
@onready var options_btn = $MarginContainer/HBoxContainer/VBoxContainer/options_btn as Button
@onready var profile_btn = $MarginContainer/HBoxContainer/VBoxContainer/profile_btn as Button
@onready var tutorial_btn = $MarginContainer/HBoxContainer/VBoxContainer/tutorial_btn as Button
@onready var exit_btn = $MarginContainer/HBoxContainer/VBoxContainer/exit_btn as Button

@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var start_level = preload("res://Scenes/In_Game_Menu/in_game_menu.tscn") as PackedScene


func _ready():
	handle_connecting_signals()
	


func on_play_presed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()
	

func on_back_to_main_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	play_btn.button_down.connect(on_play_presed)
	options_btn.button_down.connect(on_options_pressed)
	exit_btn.button_down.connect(on_exit_pressed)
	options_menu.back_to_main_btn.connect(on_back_to_main_menu)
