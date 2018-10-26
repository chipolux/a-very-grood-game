extends Node

onready var anim_player = get_node("anim_player")

func _ready():
	anim_player.play("intro")