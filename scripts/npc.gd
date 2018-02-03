extends Node2D

export(Texture) var texture
export(int) var vframes = 12
export(int) var hframes = 6
export(int) var frame = 1
export(String, MULTILINE) var phrase

func _ready():
	var interaction = get_node("interaction")
	interaction.connect("body_entered", self, "body_entered")
	interaction.connect("body_exited", self, "body_exited")
	get_node("sprite").set_texture(texture)
	get_node("sprite").set_hframes(hframes)
	get_node("sprite").set_vframes(vframes)
	get_node("sprite").set_frame(frame)

func body_entered(body):
	if body.get_name() == "player":s
		get_node("interaction_key").show()
		game_state.current_npc = self

func body_exited(body):
	if body.get_name() == "player":
		if game_state.current_npc == self:
			get_node("interaction_key").hide()
			game_state.current_npc = null