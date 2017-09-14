extends RigidBody2D

const MOVEMENT_SPEED = 200

var current_anim = ""
var interactable

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	#motion *= delta

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

	set_linear_velocity(motion * MOVEMENT_SPEED)

func _input(event):
	if event.is_action_pressed('ui_accept') and interactable:
		interactable.interact(self)

func set_player_sprite(texture):
	get_node("sprite").set_texture(texture)