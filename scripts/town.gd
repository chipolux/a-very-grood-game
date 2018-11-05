extends Node


func _ready():
	var entry_node = get_node(game_state.entry_node) if game_state.entry_node else null
	if entry_node:
		get_node("player").teleport(entry_node.position, true)
	game_state.give_weapon(game_state.WEAPONS.SWORD)
	get_node("player").set_weapon(game_state.WEAPONS.SWORD)