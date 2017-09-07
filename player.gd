extends KinematicBody2D

const MOVEMENT_SPEED = 300

slave var slave_pos = Vector2()
slave var slave_motion = Vector2()
var current_anim = ""

func _ready():
	slave_pos = get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("ui_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("ui_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("ui_down"):
			motion += Vector2(0, 1)

		motion *= delta

		rset("slave_motion", motion)
		rset("slave_pos", get_pos())
	else:
		set_pos(slave_pos)
		motion = slave_motion

	var new_anim = "standing"
	if (motion.y < 0):
		new_anim = "walk_up"
	elif (motion.y > 0):
		new_anim = "walk_down"
	elif (motion.x < 0):
		new_anim = "walk_left"
	elif (motion.x > 0):
		new_anim = "walk_right"

	if (new_anim != current_anim):
		current_anim = new_anim
		get_node("anim").play(current_anim)

	move(motion * MOVEMENT_SPEED)

	if not is_network_master():
		slave_pos = get_pos()  # to avoid jitter?

func set_player_name(name):
	get_node("label").set_text(name)

func set_player_sprite(texture):
	get_node("sprite").set_texture(texture)