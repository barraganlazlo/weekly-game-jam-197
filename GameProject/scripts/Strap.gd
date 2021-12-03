extends Line2D

export (NodePath) var bag_strap_path: NodePath
export (NodePath) var player_strap_path: NodePath

func _process(delta):
	points[0]=get_node(bag_strap_path).global_position
	points[1]=get_node(player_strap_path).global_position
