extends KinematicBody2D

const MOVEMENT_SPEED = 100
const MAX_DISTANCE = 400
const MIN_DISTANCE = 20

var target


func _ready():
	get_node("sight_area").connect("body_entered", self, "body_entered")


func _physics_process(delta):
	if target:
		var velocity = Vector2()
		var distance = global_position.distance_to(target.global_position)
		var direction = (global_position - target.global_position).normalized()
		if distance >= MAX_DISTANCE:
			# too far away, forget about em
			logger.debug("%s lost sight of the player" % get_name())
			target = null
		elif distance >= MIN_DISTANCE:
			# close enough, don't need to chase anymore
			velocity -= (direction * MOVEMENT_SPEED)
		move_and_slide(velocity)


func body_entered(body):
	if body.get_name() == "player":
		logger.debug("%s sees player" % get_name())
		target = body