extends Node

var _textures = [
	load("res://images/angel.png"),
	load("res://images/gale.png"),
	load("res://images/hobo.png"),
	load("res://images/manny.png"),
	load("res://images/shelby.png"),
	load("res://images/shroom.png"),
	load("res://images/top_hat.png"),
]
var player_texture = _textures[0]
var player_name
var players

func next_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i + 1) % _textures.size()]

func prev_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i - 1) % _textures.size()]

func start_game():
	logger.debug("start_game()")
	get_node("/root").add_child(load("res://scenes/game.tscn").instance())
	get_node("/root/main-menu").hide()

func stop_game():
	logger.debug("stop_game()")
	get_node("/root/game").queue_free()
	get_node("/root/main-menu").show()