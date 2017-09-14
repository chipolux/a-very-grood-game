extends Node2D

func _ready():
	var interaction = get_node("interaction")
	interaction.connect("body_enter", self, "body_entered")
	interaction.connect("body_exit", self, "body_exited")

func body_entered(body):
	if body.get_name() == "player":
		get_node("speech").show()
		body.interactable = self

func body_exited(body):
	if body.get_name() == "player":
		get_node("speech").hide()
		if body.interactable == self:
			body.interactable = null

func interact(player):
	get_node("speech/text").set_bbcode("HEY! I SAID DON'T TOUCH THAT!")