extends RigidBody2D
class_name PlayerLaunching

onready var player_strap_position :Vector2= $Body/StrapPosition.global_position
onready var raycasts = $Body/Raycasts
onready var body = $Body
export(float) var force :float= 2

var touched_ground:=false

func launch(bag_position:Vector2) -> void:
	bag_position.y-=32 * global_position.distance_to(bag_position) *0.015
	var direction := to_local(bag_position)
	apply_impulse(player_strap_position,direction * force)
	print("launch : ",direction, force,to_local(bag_position))

func _physics_process(delta):
	if(get_linear_velocity().x<0):
		body.scale.y=-1
	else :
		body.scale.y=1
	if(!touched_ground and _check_is_grounded()):
		touched_ground=true
		get_parent().get_parent().set_to_default_state()
	#set_linear_velocity(Vector2(get_linear_velocity().x,get_linear_velocity().y))

func _check_is_grounded() -> bool :
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func win():
	pass
