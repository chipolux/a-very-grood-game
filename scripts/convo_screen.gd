extends Control

signal done()

onready var anim_player = get_node("convo_player")
onready var left_text = get_node("convo_left/text")
onready var right_text = get_node("convo_right/text")
var in_conversation = false
var all_text_shown = false

func _ready():
	# should always start with both convo windows out and shown
	anim_player.play_backwards("both")
	anim_player.connect("animation_finished", self, "play_text")
	right_text.connect("tag_buff", self, "_on_tag")

func _on_tag(tag):
	if tag == "end":
		all_text_shown = true

func handle_input(event):
	if event.is_action_pressed("ui_accept") and all_text_shown:
		end_conversation()

func play_text(anim_name):
	left_text.set_state(left_text.STATE_OUTPUT)
	right_text.set_state(right_text.STATE_OUTPUT)

func begin_conversation(npc):
	show()
	in_conversation = true
	all_text_shown = false
	right_text.reset()
	right_text.set_color(Color(1, 1, 1))
	right_text.buff_text(npc.phrase, 0.03)
	right_text.buff_break()
	right_text.buff_break("end")
	anim_player.play("right")
	get_tree().set_pause(true)

func end_conversation():
	in_conversation = false
	anim_player.play_backwards("right")
	emit_signal("done")