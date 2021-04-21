extends KinematicBody2D
class_name Player


const UP = Vector2(0,-1)

#nodes
onready var raycasts = $Body/Raycasts
onready var body = $Body
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree

#reglages
export(float) var move_speed : float = 5
export(float) var max_jump_height : float = 2.25
export(float) var min_jump_height : float = 0.8
export(float) var jump_duration : float = 0.5

#runtime
var velocity :=Vector2(0,0)
var is_grounded :=false
var max_jump_velocity : float
var min_jump_velocity : float
var gravity : float
var animation_state_machine : AnimationNodeStateMachinePlayback
var should_jump :=false
var snap :Vector2

func _ready() -> void :
	gravity = 2 * (max_jump_height * Globals.UNIT_SIZE) / (jump_duration * jump_duration)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height * Globals.UNIT_SIZE)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height * Globals.UNIT_SIZE)
	animation_state_machine =animation_tree["parameters/playback"]

func handle_move_input() :
	var move_direction := -Input.get_action_strength("move_left") +Input.get_action_strength("move_right")
	velocity.x=move_direction * move_speed * Globals.UNIT_SIZE
	if move_direction >0:
		body.scale.x=1
	elif move_direction <0:
		body.scale.x=-1

func apply_movement() :
	velocity = move_and_slide_with_snap(velocity,Vector2.UP,snap)
func prejump():
	should_jump=true;
	animation_state_machine.travel("prejump")
	print("prejump")
func jump():
	should_jump=false;
	velocity.y=max_jump_velocity

func cut_jump():
	if velocity.y<min_jump_velocity :
		velocity.y=min_jump_velocity

func is_moving()->bool:
	return velocity.x!=0

func apply_gravity(delta) :
	velocity.y+=gravity * delta

func update_is_grounded():
	is_grounded =_check_is_grounded()

func _check_is_grounded() -> bool :
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
