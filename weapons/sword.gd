extends Node2D

var cooldown

func _ready():
	cooldown = get_node("cooldown")
	cooldown.connect("timeout", self, "finish_attack")

func attack(direction):
	if cooldown.is_stopped():
		get_node("sprite_" + direction).show()
		get_node("sound").play()
		cooldown.start()
		for body in get_node("hitbox_" + direction).get_overlapping_bodies():
			if body.is_in_group("enemies"):
				logger.debug("hit %s" % body.get_name())
				body.queue_free()

func finish_attack():
	get_node("sprite_up").hide()
	get_node("sprite_down").hide()
	get_node("sprite_right").hide()
	get_node("sprite_left").hide()