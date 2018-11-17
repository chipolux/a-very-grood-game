extends KinematicBody2D

export(NodePath) var PATROL_ROUTE
export(NodePath) var NAVMESH_PATH
export(float) var WALK_SPEED = 60
export(float) var CHASE_SPEED = 170
export(float) var CLOSE_ENOUGH = 5
export(float) var CHASE_DISTANCE = 650
export(float) var PAUSE_TIME = 3
var PATROL_POINTS = []
var NAVMESH

onready var pause_timer = get_node("pause_timer")
onready var cone = get_node("cone")
onready var cone_area = get_node("cone/area_2d")

var target
var current_point
var velocity
var path_to_point

func _ready():
	if PATROL_ROUTE:
		PATROL_POINTS = get_node(PATROL_ROUTE).get_children()
	NAVMESH = get_node(NAVMESH_PATH)
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
	elif current_point and path_to_point:
		# walk along path towards the next patrol point
		var point = path_to_point[0]
		var distance = global_position.distance_to(point)
		var direction = (global_position - point).normalized()
		cone.rotation = direction.angle() - 1.57
		if distance <= CLOSE_ENOUGH:
			path_to_point.pop_front()
		elif distance >= CLOSE_ENOUGH:
			# not to the patrol point yet, keep going
			velocity -= (direction * WALK_SPEED)
	elif current_point and not path_to_point and pause_timer.is_stopped():
		# we've just exhausted our path to the current_point, start waiting
		pause_timer.start()
	move_and_slide(velocity)

func _next_patrol_point():
	logger.debug("_next_patrol_point")
	if not PATROL_POINTS:
		return
	if not current_point:
		_set_current_point(PATROL_POINTS[0])
	else:
		var i = (PATROL_POINTS.find(current_point) + 1) % len(PATROL_POINTS)
		_set_current_point(PATROL_POINTS[i])

func _set_current_point(new_point):
	current_point = new_point
	path_to_point = []
	if new_point:
		var start = NAVMESH.to_local(global_position)
		var end = NAVMESH.to_local(current_point.global_position)
		for point in NAVMESH.get_simple_path(start, end):
			path_to_point.append(NAVMESH.to_global(point))

func _body_entered_view(body):
	if body.get_name() == "player":
		target = body

func _goto_closest_point():
	logger.debug("_goto_closest_point")
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
	_set_current_point(closest_point)