extends Node2D

var cooldown

func _ready():
	cooldown = get_node("cooldown")
	cooldown.connect("timeout", self, "finish_attack")

func attack(direction):
	if cooldown.get_time_left() == 0:
		get_node("sprite_" + direction).show()
		get_node("sound").play("sword-swish-1")
		cooldown.start()

func finish_attack():
	get_node("sprite_up").hide()
	get_node("sprite_down").hide()
	get_node("sprite_right").hide()
	get_node("sprite_left").hide()