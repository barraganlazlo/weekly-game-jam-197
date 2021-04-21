extends "res://scripts/StateMachine.gd"

onready var player:Player=$Player
var scene_default_player =preload("res://scenes/DefaultPlayer.tscn")
var scene_slingshot_player =preload("res://scenes/SlingshotPlayer.tscn")

func _ready():
	add_state("default")
	add_state("slingshot")
	add_state("launching")
	call_deferred("set_state",states.default)

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_just_pressed("slingshot") :
		set_state(states.slingshot)
	elif event.is_action_just_released("slingshot") :
		set_state(states.launching)

func _enter_state(new_state,old_state):
	match new_state:
		states.default:
			
