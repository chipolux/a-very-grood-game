extends Control

var character = 0

func _ready():
	_set_texture(character)
	get_node("start-button").connect("pressed", self, "_start_pressed")
	get_node("prev_texture").connect("pressed", self, "_prev_texture")
	get_node("next_texture").connect("pressed", self, "_next_texture")

func show_error(message):
	get_node("error").set_text(message)
	get_node("error").popup_centered_minsize()

func _set_texture(c):
	get_node("sprite").set_texture(game_state.CHARACTER_DATA[c]["texture"])

func _start_pressed():
	var name = get_node("name-input").get_text()
	if not name:
		show_error("You must have a name!")
	else:
		game_state.player_name = name
		game_state.player_character = character
		game_state.start_game()

func _prev_texture():
	character -= 1
	if character < 0:
		character = game_state.CHARACTERS.size() - 1
	_set_texture(character)

func _next_texture():
	character += 1
	if character >= game_state.CHARACTERS.size():
		character = 0
	_set_texture(character)