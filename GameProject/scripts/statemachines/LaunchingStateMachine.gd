extends "res://scripts/statemachines/StateMachine.gd"

var player_and_bag: PlayerAndBag =null
var scene_default_player_and_bag=preload("res://scenes/player/DefaultPlayer.tscn")
var scene_slingshot_player_and_bag =preload("res://scenes/player/SlingshotPlayer.tscn")
var scene_launching_player_and_bag =preload("res://scenes/player/LaunchingPlayer.tscn")
export(NodePath) var spawn_path
func _ready():
	Globals.launchingstatemachine=self
	add_state("default")
	add_state("slingshot")
	add_state("launching")
	add_state("die")
	call_deferred("set_state",states.default)

func _process(delta)->void:
	if state==states.default and Input.is_action_just_pressed("slingshot") and  player_and_bag.get_player().is_grounded:
		set_state(states.slingshot)
	elif state==states.slingshot and Input.is_action_just_released("slingshot") :
		set_state(states.launching)

func _enter_state(new_state,old_state):
	var old_player_and_bag: PlayerAndBag=player_and_bag
	var old_player=null
	var old_bag=null
	if old_player_and_bag!=null:
		old_player= old_player_and_bag.get_player() 
		old_bag=old_player_and_bag.get_bag()
	match new_state:
		states.default:
			player_and_bag=scene_default_player_and_bag.instance()
			add_child(player_and_bag)
			var player=player_and_bag.get_player()
			var bag =player_and_bag.get_bag()
			if(old_player_and_bag!=null):
				player.global_position=old_player.global_position
			else :
				bag.global_position=get_node(spawn_path).global_position
		states.slingshot:
			player_and_bag=scene_slingshot_player_and_bag.instance()
			add_child(player_and_bag)
			var player=player_and_bag.get_player()
			var bag =player_and_bag.get_bag()
			player.global_position=old_player.global_position
			bag.global_position=old_bag.global_position
			player.body.scale.x=old_player.body.scale.x
		states.launching:
			player_and_bag=scene_launching_player_and_bag.instance()
			add_child(player_and_bag)
			var player=player_and_bag.get_player()
			var bag =player_and_bag.get_bag()
			player.global_position=old_player.global_position
			player.global_position.y-=3
			bag.global_position=old_bag.global_position
			bag.launch()
		states.die:
			set_state(states.default)
			if(old_player_and_bag!=null):
				old_player_and_bag.queue_free()
			old_player_and_bag=null
	if(old_player_and_bag!=null):
		old_player_and_bag.queue_free()

func set_to_default_state():
	set_state(states.default)

func die():
	set_state(states.die)
