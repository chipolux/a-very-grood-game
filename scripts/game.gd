extends Node2D

var PLAYER_SCENE = load("res://scenes/player.tscn")

func _ready():
	set_process_input(true)
	get_node("player").set_player_sprite(game_state.player_texture)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		game_state.stop_game()