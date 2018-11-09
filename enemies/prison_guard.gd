extends KinematicBody2D

export(NodePath) var PATROL_ROUTE
export(float) var WALK_SPEED = 60
export(float) var CHASE_SPEED = 120
export(float) var CLOSE_ENOUGH = 5
export(float) var CHASE_DISTANCE = 550
export(float) var PAUSE_TIME = 3
var PATROL_POINTS = []

onready var pause_timer = get_node("pause_timer")
onready var cone = get_node("cone")
onready var cone_area = get_node("cone/area_2d")

var target
var current_point
var velocity

func _ready():
	if PATROL_ROUTE:
		PATROL_POINTS = get_node(PATROL_ROUTE).get_children()
	cone_area.connect("body_entered", self, "_body_entered_view")
	pause_timer.set_wait_time(PAUSE_TIME)
	pause_timer.connect("timeout", self, "_next_patrol_point")
	pause_timer.start()

func _physics_process(delta):
	velocity = Vector2()
	if target:
		var distance = global_position.distance_to(target.global_position)
		var direction = (global_position - target.global_position).normalized()
		cone.rotation = direction.angle() - 1.57
		if distance >= CHASE_DISTANCE:
			# too far away, forget about em
			target = null
			_goto_closest_point()
		elif distance >= CLOSE_ENOUGH:
			# not close enough, chase em!
			velocity -= (direction * CHASE_SPEED)
	elif current_point:
		# walk towards the next patrol point
		var distance = global_position.distance_to(current_point.global_position)
		var direction = (global_position - current_point.global_position).normalized()
		cone.rotation = direction.angle() - 1.57
		if distance <= CLOSE_ENOUGH and pause_timer.is_stopped():
			# we've just arrived at the patrol point
			pause_timer.start()
		elif distance >= CLOSE_ENOUGH:
			# not to the patrol point yet, keep going
			velocity -= (direction * WALK_SPEED)
	move_and_slide(velocity)

func _next_patrol_point():
	if not PATROL_POINTS:
		return
	if not current_point:
		current_point = PATROL_POINTS[0]
	else:
		var i = (PATROL_POINTS.find(current_point) + 1) % len(PATROL_POINTS)
		current_point = PATROL_POINTS[i]

func _body_entered_view(body):
	if body.get_name() == "player":
		target = body

func _goto_closest_point():
	if not PATROL_POINTS:
		return
	var min_distance = null
	var closest_point = null
	for point in PATROL_POINTS:
		var distance = point.global_position.distance_to(global_position)
		if min_distance != null and distance < min_distance:
			min_distance = distance
			closest_point = point
		elif min_distance == null:
			min_distance = distance
			closest_point = point
	current_point = closest_point