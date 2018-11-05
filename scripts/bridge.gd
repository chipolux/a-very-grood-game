extends Node2D


func _ready():
	var entry_node = get_node(game_state.entry_node) if game_state.entry_node else null
	if entry_node:
		get_node("characters/player").teleport(entry_node.position, true)