extends KinematicBody2D

export(NodePath) var PATROL_ROUTE
export(float) var WALK_SPEED = 60
export(float) var CLOSE_ENOUGH = 5
export(float) var PAUSE_TIME = 3
var PATROL_POINTS = []

onready var pause_timer = get_node("pause_timer")

var current_point
var velocity

func _ready():
	if PATROL_ROUTE:
		PATROL_POINTS = get_node(PATROL_ROUTE).get_children()
		logger.debug("%s loaded patrol route: %s" % [get_name(), PATROL_POINTS])
	pause_timer.set_wait_time(PAUSE_TIME)
	pause_timer.connect("timeout", self, "_next_patrol_point")
	pause_timer.start()

func _physics_process(delta):
	velocity = Vector2()
	if current_point:
		# walk towards the next patrol point
		var distance = global_position.distance_to(current_point.global_position)
		var direction = (global_position - current_point.global_position).normalized()
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