extends Node2D

export(Texture) var texture
export(int) var vframes = 12
export(int) var hframes = 6
export(int) var frame = 1
export(String, MULTILINE) var phrase

func _ready():
	var interaction = get_node("interaction")
	interaction.connect("body_enter", self, "body_entered")
	interaction.connect("body_exit", self, "body_exited")
	get_node("sprite").set_texture(texture)
	get_node("sprite").set_hframes(hframes)
	get_node("sprite").set_vframes(vframes)
	get_node("sprite").set_frame(frame)
	get_node("speech/text").set_bbcode(phrase)

func body_entered(body):
	if body.get_name() == "player":
		get_node("speech").show()
#		body.interactable = self

func body_exited(body):
	if body.get_name() == "player":
		get_node("speech").hide()
#		if body.interactable == self:
#			body.interactable = null

#func interact(player):
#	get_node("speech/text").set_bbcode("HEY! I SAID DON'T TOUCH THAT!")
