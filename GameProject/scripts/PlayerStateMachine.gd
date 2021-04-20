extends "res://scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")

func _state_logic(delta):
	pass
	
