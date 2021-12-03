extends Node2D


func _process(delta):
	if(global_position.direction_to(get_parent().get_player().global_position).x>0):
		$Sprite.scale.x=-1
	else:
		$Sprite.scale.x=1
