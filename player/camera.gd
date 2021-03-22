extends Spatial

var camrot_h : float = 0
var camrot_v : float = 0
var cam_v_max : float = 75
var cam_v_min : float = -55
var h_sensitivity : float = 0.1
var v_sensitivity : float = 0.1
var h_joy_sensitivity : float = 3.0
var v_joy_sensitivity : float = 2.0
var h_acceleration : float = 10
var v_acceleration : float = 10
var rot_speed_multiplier : float = 0.15 # reduce this to make the rotation radius larger

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/camera.add_exception(get_parent())

func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		$follow_debounce.start()
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += event.relative.y * v_sensitivity

func _physics_process(delta : float):
	var user_in_control : bool = (
		!$follow_debounce.is_stopped() or
		Input.is_action_pressed("cam_up") or
		Input.is_action_pressed("cam_down") or
		Input.is_action_pressed("cam_left") or
		Input.is_action_pressed("cam_right")
	)
	if user_in_control:
		camrot_h += (
			Input.get_action_strength("cam_left") - Input.get_action_strength("cam_right")
		) * h_joy_sensitivity
		camrot_v += (
			Input.get_action_strength("cam_down") - Input.get_action_strength("cam_up")
		) * v_joy_sensitivity

	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)
	if user_in_control:
		# camera responds to user input
		$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
	else:
		# camera follows character
		var mesh_front = get_node("../mesh").global_transform.basis.z
		var auto_rotate_speed =  (
			PI - mesh_front.angle_to($h.global_transform.basis.z)
		) * get_parent().velocity.length() * rot_speed_multiplier
		$h.rotation.y = lerp_angle(
			$h.rotation.y,
			get_node("../mesh").global_transform.basis.get_euler().y,
			delta * auto_rotate_speed
		)
		camrot_h = $h.rotation_degrees.y
