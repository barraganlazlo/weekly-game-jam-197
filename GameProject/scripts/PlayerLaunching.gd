extends RigidBody2D
class_name PlayerLaunching

onready var player_strap_position :Vector2= $Body/StrapPosition.global_position
onready var raycasts = $Body/Raycasts
export(float) var force :float= 2

var touched_ground:=false

func launch(bag_strap_position:Vector2) -> void:
	var direction := to_local(bag_strap_position) - to_local(player_strap_position)
	apply_impulse(player_strap_position,direction * force)
	print("launch : ",direction, force,to_local(bag_strap_position),to_local(player_strap_position))

func _process(delta):
	if(!touched_ground and _check_is_grounded()):
		touched_ground=true

func _check_is_grounded() -> bool :
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
