extends Node

var server_id = 1
var game_running = false

var _textures = [
	load("res://images/angel.png"),
	load("res://images/gale.png"),
	load("res://images/hobo.png"),
	load("res://images/manny.png"),
	load("res://images/shelby.png"),
	load("res://images/shroom.png"),
	load("res://images/top_hat.png"),
]
var player_texture = 0
var player_name
var players

func next_texture():
	player_texture = (player_texture + 1) % _textures.size()

func prev_texture():
	player_texture = (player_texture - 1) % _textures.size()

func get_texture(id):
	return _textures[id]

sync func start_game():
	logger.debug("start_game()")
	game_running = true
	get_node("/root").add_child(load("res://game.tscn").instance())
	get_node("/root/main-menu").hide()

sync func stop_game():
	logger.debug("stop_game()")
	game_running = false
	get_node("/root/game").queue_free()
	get_node("/root/main-menu").show()