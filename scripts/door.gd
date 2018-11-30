extends Node2D


onready var anim_player = get_node("anim_player")

export(bool) var open = true
export(bool) var locked = false


func _ready():
	get_node("button").connect("body_entered", self, "body_entered")
	get_node("button").connect("body_exited", self, "body_exited")
	if open:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")

func body_entered(body):
	if body.get_name() == "player":
		game_state.current_interactable = self

func body_exited(body):
	if body.get_name() == "player":
		if game_state.current_interactable == self:
			game_state.current_interactable = null

func interact():
	if anim_player.is_playing():
		return
	if locked:
		return
	open = not open
	if open:
		anim_player.play("open")
		get_node("open_audio").play()
	else:
		anim_player.play_backwards("open")
		get_node("close_audio").play()