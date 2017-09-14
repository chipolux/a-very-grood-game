extends Control

func _ready():
	get_node("sprite").set_texture(game_state.player_texture)
	get_node("start-button").connect("pressed", self, "_start_pressed")
	get_node("prev_texture").connect("pressed", self, "_prev_texture")
	get_node("next_texture").connect("pressed", self, "_next_texture")

func show_error(message):
	get_node("error").set_text(message)
	get_node("error").popup_centered_minsize()

func _start_pressed():
	var name = get_node("name-input").get_text()
	if not name:
		show_error("You must have a name!")
	else:
		game_state.player_name = name
		game_state.start_game()

func _prev_texture():
	game_state.prev_texture()
	get_node("sprite").set_texture(game_state.player_texture)

func _next_texture():
	game_state.next_texture()
	get_node("sprite").set_texture(game_state.player_texture)