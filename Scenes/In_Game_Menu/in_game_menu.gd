extends Control

@onready var game = $MarginContainer/VBoxContainer/Game
@onready var moves_label = $MarginContainer/VBoxContainer/HBoxContainer/Moves
@onready var time_label = $MarginContainer/VBoxContainer/HBoxContainer/Time
@onready var restart_btn = $MarginContainer/HBoxContainer2/RestartGameBtn
@onready var main_menu_btn = $MarginContainer/HBoxContainer2/MainMenuBtn
@onready var puzzle_settings_btn = $MarginContainer/HBoxContainer2/PuzzleSettingsBtn
@onready var pause_game_btn = $MarginContainer/HBoxContainer2/PauseGameBtn
@onready var animation_player = $AnimationPlayer

var settings_scene: PackedScene = preload("res://Scenes/In_Game_Settings/in_game_settings.tscn")
var settings_instance: Control = null

var time_elapsed = 0
var timer: Timer
var is_paused = false
var was_paused_before_settings = false

func _ready():
	connect_signals()
	setup_timer()
	setup_pause_group()

func connect_signals():
	restart_btn.pressed.connect(on_restart_pressed)
	main_menu_btn.pressed.connect(on_main_menu_pressed)
	puzzle_settings_btn.pressed.connect(on_SettingsButton_pressed)
	pause_game_btn.pressed.connect(on_pause_game_pressed)
	game.connect("move_made", on_move_made)
	game.connect("puzzle_solved", on_puzzle_solved)

func setup_timer():
	timer = Timer.new()
	timer.connect("timeout", on_timer_timeout)
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

func setup_pause_group():
	game.add_to_group("Pausable")
	timer.add_to_group("Pausable")

func on_restart_pressed():
	game.start_game()
	reset_ui()
	timer.start()
	unpause_game()

func on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu/main_menu.tscn")

func on_SettingsButton_pressed():
	was_paused_before_settings = is_paused
	pause_game()
	if not settings_instance:
		settings_instance = settings_scene.instantiate()
		add_child(settings_instance)
		settings_instance.settings_closed.connect(on_settings_closed)

func on_settings_closed():
	settings_instance = null
	if not was_paused_before_settings:
		unpause_game()

func on_SettingsScreen_hide_settings():
	animation_player.play_backwards("show_settings")
	if not was_paused_before_settings:
		unpause_game()

func on_move_made(moves):
	moves_label.text = "Moves: " + str(moves)

func on_puzzle_solved():
	timer.stop()
	print("Puzzle solved! Time: ", time_elapsed, " seconds")

func on_timer_timeout():
	time_elapsed += 1
	update_time_label()

func update_time_label():
	var minutes = time_elapsed / 60
	var seconds = time_elapsed % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func reset_ui():
	time_elapsed = 0
	update_time_label()
	moves_label.text = "Moves: 0"

func on_pause_game_pressed():
	if is_paused:
		unpause_game()
	else:
		pause_game()

func pause_game():
	if not is_paused:
		is_paused = true
		get_tree().call_group("Pausable", "set_process", false)
		get_tree().call_group("Pausable", "set_physics_process", false)
		get_tree().call_group("Pausable", "set_process_input", false)
		timer.paused = true
		pause_game_btn.text = "Unpause"

func unpause_game():
	if is_paused:
		is_paused = false
		get_tree().call_group("Pausable", "set_process", true)
		get_tree().call_group("Pausable", "set_physics_process", true)
		get_tree().call_group("Pausable", "set_process_input", true)
		timer.paused = false
		pause_game_btn.text = "Pause"
