extends "res://scripts/player/Player.gd"

export(float) var max_distance :float =100

onready var jump_audio_source= $Body/JumpAudioStream
onready var sprite= $Body/Sprite
	
onready var bag = get_node("../BagSlingshot")

func _ready() -> void :
	gravity = 2 * (max_jump_height * Globals.UNIT_SIZE) / (jump_duration * jump_duration)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height * Globals.UNIT_SIZE)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height * Globals.UNIT_SIZE)
func get_animation_tree():
	pass
func handle_move_input(delta) :
	var move_direction := -Input.get_action_strength("move_left") +Input.get_action_strength("move_right")
	velocity.x=move_direction * move_speed * Globals.UNIT_SIZE
	if move_direction <0:
		body.scale.x=1
	elif move_direction >0:
		body.scale.x=-1
func apply_movement(delta):
	var new_pos = global_position + velocity * delta
	var distance_exess =new_pos.distance_to(bag.global_position) - max_distance 
	if distance_exess > 0:
		print(new_pos.distance_to(bag.global_position),velocity,distance_exess * new_pos.direction_to(bag.global_position))
		velocity+=velocity.length() * new_pos.direction_to(bag.global_position)
		
	.apply_movement(delta)

func _process(delta):
	var distance_ratio = global_position.distance_to(bag.global_position) / max_distance 
	sprite.frame= int(round(distance_ratio * (sprite.hframes- 1))) 
func prejump():
	jump_audio_source.play()
	jump()

func get_animation_state_machine():
	pass
