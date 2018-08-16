extends Control

signal done()

onready var anim_player = get_node("convo_player")
onready var right_text = get_node("convo_right/text")
onready var right_face = get_node("convo_right/face")

var in_conversation = false
var all_text_shown = false
var on_break = false

func _ready():
	# should always start with both convo windows out and shown
	anim_player.play_backwards("both")
	anim_player.connect("animation_finished", self, "play_text")
	right_text.connect("tag_buff", self, "_on_tag")
	right_text.connect("enter_break", self, "_on_break")

func _on_tag(tag):
	if tag == "end":
		all_text_shown = true

func _on_break():
	on_break = true

func handle_input(event):
	if event.is_action_pressed("ui_accept"):
		if all_text_shown:
			logger.debug("ending conversation")
			end_conversation()
		elif on_break:
			on_break = false
		else:
			logger.debug("entering turbo mode")
			right_text.set_buff_speed(0)

func play_text(anim_name):
	right_text.set_state(right_text.STATE_OUTPUT)

func begin_conversation(npc):
	show()
	on_break = false
	in_conversation = true
	all_text_shown = false
	right_face.texture = npc.texture
	right_face.hframes = npc.hframes
	right_face.vframes = npc.vframes
	right_face.frame = npc.frame
	right_text.reset()
	right_text.set_color(Color(1, 1, 1))
	right_text.buff_text(npc.phrase, 0.03)
	right_text.buff_break("end")
	anim_player.play("right")
	get_tree().set_pause(true)

func end_conversation():
	in_conversation = false
	anim_player.play_backwards("right")
	emit_signal("done")