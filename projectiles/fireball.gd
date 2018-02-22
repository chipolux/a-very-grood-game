extends Node2D

const SPEED = 450
const MAX_DISTANCE = 350
const DAMAGE = 4
const KNOCKBACK = 3000  # TODO: find out why this is so high?

var start_position
var start_direction


func _ready():
	get_node("sprite").hide()
	connect("body_entered", self, "_on_body_entered")


func _process(delta):
	if global_position.distance_to(start_position) > MAX_DISTANCE:
		if get_node("anim_player").current_animation != "fizzle":
			get_node("anim_player").play("fizzle")


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.hit(DAMAGE, start_direction * KNOCKBACK)
	if not body.is_in_group("fireballs"):
		if get_node("anim_player").current_animation != "explode":
			get_node("anim_player").play("explode")


func launch(direction):
	start_position = global_position
	start_direction = direction
	set_linear_velocity(direction * SPEED)
	get_node("sprite").rotate(Vector2(-direction.x, direction.y).angle_to(Vector2(1, 0)))
	get_node("anim_player").play("spawn")