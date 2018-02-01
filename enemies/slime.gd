extends KinematicBody2D

const FOLLOW_SPEED = 100
const WANDER_SPEED = 50

const FOLLOW_DISTANCE = 400
const WANDER_DISTANCE = 100
const CLOSE_ENOUGH = 20

var target
var anchor_point
var interest_point
var interest_timer


func _ready():
	get_node("sight_area").connect("body_entered", self, "body_entered")
	interest_timer = get_node("interest_timer")
	interest_timer.connect("timeout", self, "update_interest_point")
	anchor_point = global_position
	update_interest_point()


func _physics_process(delta):
	var velocity = Vector2()
	if target:
		var distance = global_position.distance_to(target.global_position)
		var direction = (global_position - target.global_position).normalized()
		if distance >= FOLLOW_DISTANCE:
			# too far away, forget about em and anchor ourselves
			logger.debug("%s lost sight of the target" % get_name())
			anchor_point = global_position
			update_interest_point()
			target = null
		elif distance >= CLOSE_ENOUGH:
			# not close enough, chase em!
			velocity -= (direction * FOLLOW_SPEED)
	else:
		# wander towards the interest point
		var distance = global_position.distance_to(interest_point)
		var direction = (global_position - interest_point).normalized()
		if distance <= CLOSE_ENOUGH and interest_timer.is_stopped():
			# we've just arrived at the interest point
			interest_timer.set_wait_time(rand_range(0, 2.5))
			interest_timer.start()
		elif distance >= CLOSE_ENOUGH:
			# not to the interest point yet, keep going
			velocity -= (direction * min(distance, WANDER_SPEED))

	var collision = move_and_collide(velocity * delta)
	if collision and not target and not collision.collider.is_in_group("enemies"):
		# we are colliding with something while wondering
		update_interest_point()
	elif collision and collision.collider.is_in_group("enemies"):
		# we are colliding with another enemy
		move_and_slide(velocity)


func body_entered(body):
	if body.get_name() == "player":
		logger.debug("%s sees player" % get_name())
		target = body


func update_interest_point():
	randomize()
	var x = rand_range(anchor_point.x - WANDER_DISTANCE, anchor_point.x + WANDER_DISTANCE)
	var y = rand_range(anchor_point.y - WANDER_DISTANCE, anchor_point.y + WANDER_DISTANCE)
	interest_point = Vector2(x, y)