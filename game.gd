extends Node2D

var PLAYER_SCENE = load("res://player.tscn")

func _ready():
	set_process_input(true)
	for player_id in game_state.players:
		create_player(player_id)
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")

func _input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().is_network_server():
		game_state.rpc("stop_game")

func _on_network_peer_disconnected(id):
	get_node("players/%s" % id).queue_free()

func create_player(id):
	var player = PLAYER_SCENE.instance()
	player.set_name(str(id))
	player.set_player_name(game_state.players[id]["name"])
	player.set_player_sprite(game_state.get_texture(game_state.players[id]["texture"]))
	if id == get_tree().get_network_unique_id():
		player.set_network_mode(NETWORK_MODE_MASTER)
	else:
		player.set_network_mode(NETWORK_MODE_SLAVE)
	get_node("players").add_child(player)