extends Node2D


onready var anim_player = get_node("anim_player")
onready var proximity = get_node("proximity")
onready var button = get_node("button")

export(bool) var open = true
export(bool) var locked = false
export(bool) var auto = true
var bodies_in_proximity = []


func _ready():
	button.connect("body_entered", self, "body_entered_button")
	button.connect("body_exited", self, "body_exited_button")
	proximity.connect("body_entered", self, "body_entered_proximity")
	proximity.connect("body_exited", self, "body_exited_proximity")
	if open:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")

func body_entered_button(body):
	if body.get_name() == "player" and not auto:
		game_state.current_interactable = self

func body_exited_button(body):
	if body.get_name() == "player" and not auto:
		if game_state.current_interactable == self:
			game_state.current_interactable = null

func body_entered_proximity(body):
	bodies_in_proximity.append(body)
	if auto and not locked and not open:
		open_door()

func body_exited_proximity(body):
	bodies_in_proximity.erase(body)
	if auto and not locked and not bodies_in_proximity:
		close_door()

func interact():
	if anim_player.is_playing():
		return
	if locked:
		return
	if open:
		close_door()
	else:
		open_door()

func close_door():
	open = false
	anim_player.play_backwards("open")
	get_node("close_audio").play()

func open_door():
	open = true
	anim_player.play("open")
	get_node("open_audio").play()