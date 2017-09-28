extends Node2D

func _ready():
	set_process_input(true)
	var area_1 = load("res://scenes/area-1.tscn").instance()
	area_1.set_name("current-area")
	add_child(area_1)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		game_state.stop_game()