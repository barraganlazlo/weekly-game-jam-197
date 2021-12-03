extends "res://scripts/statemachines/StateMachine.gd"

onready var player:Player= get_parent()
onready var landing_audiostream=get_node("../Body/LandingAudioStream")
onready var jump_audiostream=get_node("../Body/JumpAudioStream")
const snap_active:=Vector2(0, 8)

var realeased_jump :=true
var spawn=false
func _ready():
	add_state("idle")
	add_state("walk")
	add_state("prejump")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state",states.idle)

func _unhandled_input(event:InputEvent) -> void:
	if [states.idle, states.walk].has(state) :
		if event.is_action_pressed("jump") && !player.should_jump :
			realeased_jump=false
			player.prejump()
	if event.is_action_released("jump"):
		realeased_jump=true
		player.cut_jump()

func _physics_state_logic(delta):
	player.handle_move_input(delta)
	player.apply_gravity(delta)
	player.apply_movement(delta) 
	player.update_is_grounded() 
	
func _get_transition(delta):
	match state:
		states.idle:
			if !player.is_grounded:
				if player.velocity.y>=0:
					return states.fall
				
			elif player.should_jump :
				return states.prejump
			elif player.is_moving() :
				return states.walk
		states.walk:
			if !player.is_grounded:
				if player.velocity.y>=0:
					return states.fall
				
			elif player.should_jump :
				return states.prejump
			elif !player.is_moving() :
				return states.idle
		states.prejump:
			if player.velocity.y<0 :
				return states.jump
		states.jump:
			if player.velocity.y<0 :
				return null
			elif player.is_grounded:
				return states.idle
			elif player.velocity.y>=0 :
				return states.fall
		states.fall:
			if player.is_grounded:
				return states.idle
			elif player.velocity.y<0 :
				return states.jump
	return null
	
func _exit_state(new_state,old_state):
	match old_state:
		states.fall:
			landing_audiostream.play()
	
func _enter_state(new_state,old_state):
	match new_state:
		states.idle:
			player.snap=snap_active
			if(player.animation_state_machine!=null):
				player.animation_state_machine.travel("idle")
		states.walk:
			player.snap=snap_active
			if(player.animation_state_machine!=null):
				player.animation_state_machine.travel("walk")
		states.prejump:
			player.snap=Vector2.ZERO
			jump_audiostream.play()
			if(player.animation_state_machine!=null):
				player.animation_state_machine.travel("prejump")
		states.jump:
			player.snap=Vector2.ZERO
			if(player.animation_state_machine!=null):
				player.animation_state_machine.travel("jump")
		states.fall:
			player.snap=snap_active
			if(player.animation_state_machine!=null):
				player.animation_state_machine.travel("fall")
