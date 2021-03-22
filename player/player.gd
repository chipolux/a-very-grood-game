extends KinematicBody

var direction : Vector3 = Vector3.BACK
var velocity : Vector3 = Vector3.ZERO
var strafe_dir : Vector3 = Vector3.ZERO
var vertical_velocity : float = 0
export var gravity : float = 20
var movement_speed : float = 0
export var walk_speed : float = 3.5
export var run_speed : float = 6.5
export var jump_strength : float = -5
export var acceleration : float = 6
export var angular_acceleration : float = 12

func _ready():
	# handle when player object has been rotated in the scene
	direction = Vector3.BACK.rotated(Vector3.UP, $cam_root/h.global_transform.basis.get_euler().y)

func _process(_delta : float):
	$hud/debug_panel/debug_label.bbcode_text = (
	"""
	[table=2]
	[cell]cam_up:[/cell][cell]%s[/cell]
	[cell]cam_down:[/cell][cell]%s[/cell]
	[cell]cam_left:[/cell][cell]%s[/cell]
	[cell]cam_right:[/cell][cell]%s[/cell]
	[cell]strafe_dir:[/cell][cell]%s[/cell]
	[/table]
	""" % [
		Input.is_action_pressed("cam_up"),
		Input.is_action_pressed("cam_down"),
		Input.is_action_pressed("cam_left"),
		Input.is_action_pressed("cam_right"),
		strafe_dir,
	]).strip_edges()
	if strafe_dir.x == 1:
		$sprite.animation = "walk_left"
	elif strafe_dir.x == -1:
		$sprite.animation = "walk_right"
	elif strafe_dir.z == 1:
		$sprite.animation = "walk_up"
	elif strafe_dir.z == -1:
		$sprite.animation = "walk_down"
	else:
		$sprite.animation = "stand"

func _physics_process(delta : float):
	var h_rot : float = $cam_root/h.global_transform.basis.get_euler().y
	var user_in_control : bool = (
		Input.is_action_pressed("forward") or
		Input.is_action_pressed("backward") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")
	)
	if user_in_control:
		direction = Vector3(
			Input.get_action_strength("left") - Input.get_action_strength("right"),
			0,
			Input.get_action_strength("forward") - Input.get_action_strength("backward")
		)
		strafe_dir = direction
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
		movement_speed = 0
		strafe_dir = Vector3.ZERO

	if Input.is_action_pressed("jump") and is_on_floor():
		vertical_velocity = jump_strength

	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)
	var _new_velocity : Vector3 = move_and_slide(
		velocity + Vector3.DOWN * vertical_velocity,
		Vector3.UP,
		true
	)
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0

	$mesh.rotation.y = lerp_angle(
		$mesh.rotation.y,
		atan2(direction.x, direction.z) - rotation.y,
		delta * angular_acceleration
	)
