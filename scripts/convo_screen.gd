extends Control

var anim_player
var left_text
var right_text
var in_conversation = false

func _ready():
	anim_player = get_node("convo_player")
	left_text = get_node("convo_left/text")
	right_text = get_node("convo_right/text")
	# should always start with both convo windows out
	show()
	anim_player.play_backwards("both")

func begin_conversation(npc):
	in_conversation = true
	right_text.set_bbcode("[right]" + npc.phrase + "[/right]")
	anim_player.play("right")
	get_tree().set_pause(true)

func end_conversation():
	in_conversation = false
	right_text.set_bbcode("")
	anim_player.play_backwards("right")
	get_tree().set_pause(false)

func _input(event):
	if event.is_action_pressed('ui_accept'):
		if in_conversation:
			end_conversation()
		elif game_state.current_npc:
			begin_conversation(game_state.current_npc)