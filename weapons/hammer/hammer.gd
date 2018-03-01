extends Node2D

export(int) var DAMAGE = 4
export(int) var KNOCKBACK = 3000  # TODO: find out why this is so high?

var NAME = "Hammer"
var ICON = load("res://weapons/hammer/icon.png")

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
		var direction = (body.global_position - global_position).normalized()
		body.hit(DAMAGE, direction * KNOCKBACK)