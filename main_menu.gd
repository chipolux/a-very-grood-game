extends Control

func _ready():
	get_node("sprite").set_texture(game_state.get_texture(game_state.player_texture))

	get_node("chat").set_scroll_follow(true)
	get_node("name-input").connect("text_entered", self, "_name_entered")
	get_node("host-button").connect("pressed", self, "_host_pressed")
	get_node("connect-button").connect("pressed", self, "_connect_pressed")
	get_node("disconnect-button").connect("pressed", self, "_disconnect_pressed")
	get_node("start-button").connect("pressed", self, "_start_pressed")
	get_node("send-button").connect("pressed", self, "_send_pressed")
	get_node("message-input").connect("text_entered", self, "_text_entered")
	get_node("prev_texture").connect("pressed", self, "_prev_texture")
	get_node("next_texture").connect("pressed", self, "_next_texture")

	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func show_error(message):
	get_node("error").set_text(message)
	get_node("error").popup_centered_minsize()

func _host_pressed():
	game_state.player_name = get_node("name-input").get_text()
	game_state.players = {game_state.server_id: {"name": game_state.player_name, "texture": game_state.player_texture}}
	if game_state.player_name:
		var port = get_node("port-input").get_text().to_int()
		if game_state.host_game(port, 20):
			disable_connect()
			enable_chat()
			get_node("start-button").set_hidden(false)
			insert_message("Hosting server!")
	else:
		show_error("You must set a player name!")

func _connect_pressed():
	game_state.player_name = get_node("name-input").get_text()
	game_state.players = {}
	if game_state.player_name:
		var port = get_node("port-input").get_text().to_int()
		var ip = get_node("ip-input").get_text()
		if game_state.join_game(ip, port):
			disable_connect()
			insert_message("Connecting to server...")
	else:
		show_error("You must set a player name!")

func _disconnect_pressed():
	leave_game()

func _name_entered(text):
	_connect_pressed()

func _send_pressed():
	send_message(get_node("message-input").get_text())
	get_node("message-input").clear()

func _text_entered(text):
	send_message(text)
	get_node("message-input").clear()

func _start_pressed():
	# should only be 'pressable' by the server player
	game_state.rpc("start_game")

func _prev_texture():
	game_state.prev_texture()
	get_node("sprite").set_texture(game_state.get_texture(game_state.player_texture))

func _next_texture():
	game_state.next_texture()
	get_node("sprite").set_texture(game_state.get_texture(game_state.player_texture))


func _on_network_peer_connected(id):
	logger.debug("network_peer_connected(%s)" % id)

func _on_network_peer_disconnected(id):
	logger.debug("network_peer_disconnected(%s)" % id)
	insert_message("%s disconnected." % game_state.players[id]["name"])
	game_state.players.erase(id)

func _on_connected_to_server():
	logger.debug("connected_to_server()")
	insert_message("Connected to server!")
	game_state.rpc_id(
		game_state.server_id,
		"register_player",
		get_tree().get_network_unique_id(),
		game_state.player_name,
		game_state.player_texture
	)
	enable_chat()

func _on_connection_failed():
	logger.debug("connection_failed()")
	insert_message("Failed to connect to server...")
	leave_game()

func _on_server_disconnected():
	logger.debug("server_disconnected()")
	insert_message("Server disconnected...")
	leave_game()

func send_message(text):
	if text:
		logger.debug("sending %s" % text)
		rpc("insert_message", "%s: %s" % [game_state.player_name, text])

sync func insert_message(message):
	get_node("chat").add_text(message)
	get_node("chat").newline()

func leave_game():
	game_state.leave_game()
	enable_connect()
	disable_chat()
	get_node("start-button").set_hidden(true)
	insert_message("Disconnected...")

func enable_connect():
	get_node("host-button").set_disabled(false)
	get_node("connect-button").set_disabled(false)
	get_node("disconnect-button").set_disabled(true)
	get_node("name-input").set_editable(true)
	get_node("ip-input").set_editable(true)
	get_node("port-input").set_editable(true)
	get_node("next_texture").show()
	get_node("prev_texture").show()

func disable_connect():
	get_node("host-button").set_disabled(true)
	get_node("connect-button").set_disabled(true)
	get_node("disconnect-button").set_disabled(false)
	get_node("name-input").set_editable(false)
	get_node("ip-input").set_editable(false)
	get_node("port-input").set_editable(false)
	get_node("next_texture").hide()
	get_node("prev_texture").hide()

func enable_chat():
	get_node("send-button").set_disabled(false)
	get_node("message-input").set_editable(true)
	get_node("message-input").set_focus_mode(FOCUS_ALL)
	get_node("message-input").clear()

func disable_chat():
	get_node("send-button").set_disabled(true)
	get_node("message-input").set_editable(false)
	get_node("message-input").set_focus_mode(FOCUS_NONE)
	get_node("message-input").clear()