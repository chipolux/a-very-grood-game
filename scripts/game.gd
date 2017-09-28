extends Node2D

func _ready():
	set_process_input(true)
	var bridge = load("res://scenes/bridge.tscn").instance()
	bridge.set_name("current-area")
	add_child(bridge)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		game_state.stop_game()