extends Area2D

export(String, FILE, "*tscn") var scene
export(String) var entry_node = null

func _ready():
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.05
	timer.autostart = true
	timer.set_name("timer")
	timer.connect("timeout", self, "_timer_finished")
	add_child(timer)

func _timer_finished():
	get_node("timer").queue_free()
	connect("body_entered", self, "body_entered")

func body_entered(body):
	logger.debug("%s.body_entered(%s)" % [get_name(), body.get_name()])
	if body.get_name() == "player" and scene:
		game_state.set_scene(scene, entry_node)