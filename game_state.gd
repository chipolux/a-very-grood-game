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

func _ready():
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func _on_network_peer_disconnected(id):
	logger.debug("network_peer_disconnected(%s)" % id)
	get_node("/root/main-menu").insert_message("%s disconnected." % players[id]["name"])
	players.erase(id)

func _on_connected_to_server():
	logger.debug("connected_to_server()")
	get_node("/root/main-menu").insert_message("Connected to server!")
	rpc_id(
		server_id,
		"register_player",
		get_tree().get_network_unique_id(),
		player_name,
		player_texture
	)
	enable_chat()

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

func leave_game():
	if game_running:
		stop_game()
	get_tree().set_network_peer(null)

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

remote func register_player(id, name, texture):
	if get_tree().is_network_server():
		for player_id in players:
			if player_id != server_id:
				rpc_id(player_id, "register_player", id, name, texture)
	players[id] = {"name": name, "texture": texture}
	rpc_id(id, "register_players", players)
	get_node("/root/main-menu").insert_message("%s connected!" % name)

remote func register_players(existing_players):
	players = existing_players
	var message = "Already Online: "
	for player_id in players:
		if player_id != get_tree().get_network_unique_id():
			message += players[player_id]["name"] + ", "
	message = message.left(message.length() - 2)
	get_node("/root/main-menu").insert_message(message)