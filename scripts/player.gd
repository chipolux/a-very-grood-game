extends KinematicBody2D

const MOVEMENT_SPEED = 250

var current_anim = "stand_down"
var npc
var in_conversation = false

func _ready():
	set_physics_process(true)
	set_process_input(true)
	get_node("sprite").set_texture(game_state.player_texture)

func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right") and not in_conversation:
		velocity.x += MOVEMENT_SPEED
	if Input.is_action_pressed("ui_left") and not in_conversation:
		velocity.x -= MOVEMENT_SPEED
	if Input.is_action_pressed("ui_down") and not in_conversation:
		velocity.y += MOVEMENT_SPEED
	if Input.is_action_pressed("ui_up") and not in_conversation:
		velocity.y -= MOVEMENT_SPEED
	move_and_slide(velocity)

	var new_anim = "stand_down"
	if (velocity.y < 0):
		new_anim = "walk_up"
	elif (velocity.y > 0):
		new_anim = "walk_down"
	elif (velocity.x < 0):
		new_anim = "walk_left"
	elif (velocity.x > 0):
		new_anim = "walk_right"
	else:
		new_anim = "stand_" + current_anim.split("_")[1]
	if (new_anim != current_anim):
		current_anim = new_anim
		get_node("anim").play(current_anim)

func _input(event):
	if event.is_action_pressed('ui_accept') and npc:
		if in_conversation:
			end_conversation()
		else:
			begin_conversation()
	if event.is_action_pressed("ui_cancel"):
		game_state.stop_game()
	if event.is_action_pressed("attack_l") and not in_conversation:
		attack_with_left_hand()
	if event.is_action_pressed("attack_r") and not in_conversation:
		attack_with_right_hand()

func set_player_sprite(texture):
	get_node("sprite").set_texture(texture)

func attack_with_left_hand():
	var direction = current_anim.split("_")[1]
	if has_node("weapon_left"):
		get_node("weapon_left").attack(direction)

func attack_with_right_hand():
	var direction = current_anim.split("_")[1]
	if has_node("weapon_right"):
		get_node("weapon_right").attack(direction)

func begin_conversation():
	in_conversation = true
	get_node("ui/convo_left/text").set_bbcode("Hi!")
	get_node("ui/convo_right/text").set_bbcode("[right]" + npc.phrase + "[/right]")
	get_node("ui/convo_player").play("both")

func end_conversation():
	in_conversation = false
	get_node("ui/convo_player").play_backwards("both")

func targeted_by(enemy):
	get_node("found").play()