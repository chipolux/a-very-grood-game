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

func host_game(port, max_peers):
	logger.debug("host_game(%s, %s)" % [port, max_peers])
	var host = NetworkedMultiplayerENet.new()
	if host.create_server(port, max_peers) == OK:
		logger.debug("create_server(%s, %s)" % [port, max_peers])
		get_tree().set_network_peer(host)
		return true
	logger.error("create_server failed")
	return false

func join_game(ip, port):
	logger.debug("join_game(%s, %s)" % [ip, port])
	var host = NetworkedMultiplayerENet.new()
	if host.create_client(ip, port) == OK:
		logger.debug("create_client(%s, %s)" % [ip, port])
		get_tree().set_network_peer(host)
		return true
	logger.error("create_client failed")
	return false

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