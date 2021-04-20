extends KinematicBody2D

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
var released_jump :=true
var max_jump_velocity : float
var min_jump_velocity : float
var gravity : float
var state_machine : AnimationNodeStateMachinePlayback
func _ready() -> void :
	gravity = 2 * max_jump_height / (jump_duration * jump_duration)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	state_machine =animation_tree["parameters/playback"]

func _physics_process(delta:float) -> void :
	var move_direction := -Input.get_action_strength("move_left") +Input.get_action_strength("move_right")
	velocity.x=move_direction * move_speed * Globals.UNIT_SIZE
	if move_direction >0:
		body.scale.x=1
	elif move_direction <0:
		body.scale.x=-1
	velocity.y+=gravity * Globals.UNIT_SIZE * delta
	is_grounded =_check_is_grounded()
	velocity = move_and_slide(velocity,UP,true)

func _process(_delta:float)-> void :
	_process_state()

func _unhandled_input(event:InputEvent):
	if event.is_action_pressed("jump") && is_grounded && released_jump :
		released_jump = false
		velocity.y=max_jump_velocity * Globals.UNIT_SIZE
		#state_machine.travel("jump")
	if event.is_action_released("jump"):
		released_jump = true
		if velocity.y < min_jump_velocity :
			velocity.y = min_jump_velocity

func _check_is_grounded() -> bool :
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _process_state() -> void :
	var current_anim: String=animation_player.assigned_animation
	var anim :String=current_anim
	if(is_grounded and velocity.y==0) :
		if(velocity.x!=0) :
			state_machine.travel("walk")
		else: 
			state_machine.travel("idle")
	else:
		if velocity.y > 0 :
			state_machine.travel("falling")
		elif velocity.y < 0 :
			state_machine.travel("jumping")
