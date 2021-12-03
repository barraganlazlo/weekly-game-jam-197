extends RigidBody2D

export(float) var max_distance:float=50
export(float) var distance_to_get_bag:float=5
export(float) var force_factor:float=0.1


onready var bag_strap_position:Vector2 =$Body/StrapPosition.global_position
onready var body =$Body
onready var player:PlayerLaunching= get_node("../PlayerLaunching")

func launch():
	player.launch(global_position)

func _physics_process(delta):
	var player_relative_position = player.global_position - global_position
	var player_direction = player_relative_position.normalized()
	if player_relative_position.x>5 :
		body.scale.x=-1
	elif player_relative_position.x<5:
		body.scale.x=1
	var player_distance = player_relative_position.length()
	var force=player_distance - max_distance
	max_distance*=0.98
	if(force>0):
		var velocity=(player_direction * force * force_factor)
		set_linear_velocity(velocity)
	else :
		set_linear_velocity(get_linear_velocity()*0.9)
