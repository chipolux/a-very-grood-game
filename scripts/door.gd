extends Node2D


onready var interaction_key = get_node("interaction_key")


func _ready():
	get_node("button").connect("body_entered", self, "body_entered")
	get_node("button").connect("body_exited", self, "body_exited")
	interaction_key.hide()

func body_entered(body):
	if body.get_name() == "player":
		interaction_key.show()
		game_state.current_interactable = self

func body_exited(body):
	if body.get_name() == "player":
		if game_state.current_interactable == self:
			interaction_key.hide()
			game_state.current_interactable = null

func interact():
	queue_free()