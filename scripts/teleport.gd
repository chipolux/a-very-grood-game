extends Area2D

export(NodePath) var destination
var _destination


func _ready():
	if not destination.is_empty():
		_destination = get_node(destination)
	connect("body_entered", self, "teleport")

func teleport(body):
	if body.get_name() == "player" and _destination:
		logger.debug("teleporting player")
		body.teleport(_destination.position)