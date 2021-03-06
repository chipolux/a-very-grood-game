extends Node

onready var anim_player = get_node("anim_player")

func _ready():
	var entry_node = get_node(game_state.entry_node) if game_state.entry_node else null
	if entry_node:
		get_node("player").teleport(entry_node.position, true)
	get_node("intro_junk/prisoner").texture = game_state.CHARACTER_DATA[game_state.player_character]["texture"]
	anim_player.play("intro")