extends Node

onready var anim_player = get_node("anim_player")

func _ready():
	get_node("intro_junk/prisoner").texture = game_state.player_texture
	anim_player.play("intro")