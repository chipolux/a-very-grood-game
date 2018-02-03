extends Node2D


func _ready():
	get_node("hitbox_left").monitoring = false
	get_node("hitbox_right").monitoring = false
	get_node("hitbox_up").monitoring = false
	get_node("hitbox_down").monitoring = false
	get_node("sprite_left").hide()
	get_node("sprite_right").hide()
	get_node("sprite_up").hide()
	get_node("sprite_down").hide()

func attack(direction):
	if not get_node("anim_player").is_playing():
		get_node("anim_player").play(direction)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		logger.debug("hitting %s" % body.get_name())
		body.queue_free()