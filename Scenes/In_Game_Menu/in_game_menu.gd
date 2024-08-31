extends Control

@onready var game = $MarginContainer/VBoxContainer/Game
@onready var moves_label = $MarginContainer/VBoxContainer/HBoxContainer/Moves
@onready var time_label = $MarginContainer/VBoxContainer/HBoxContainer/Time
@onready var restart_btn = $MarginContainer/HBoxContainer2/RestartGameBtn
@onready var main_menu_btn = $MarginContainer/HBoxContainer2/MainMenuBtn

var time_elapsed = 0
var timer: Timer

func _ready():
	connect_signals()
	setup_timer()

func connect_signals():
	restart_btn.pressed.connect(on_restart_pressed)
	main_menu_btn.pressed.connect(on_main_menu_pressed)
	game.connect("move_made", on_move_made)
	game.connect("puzzle_solved", on_puzzle_solved)

func setup_timer():
	timer = Timer.new()
	timer.connect("timeout", on_timer_timeout)
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

func on_restart_pressed():
	game.start_game()  # Call start_game() on the game instance
	reset_ui()
	timer.start()  # Restart the timer

func on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu/main_menu.tscn")

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
