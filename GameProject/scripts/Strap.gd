extends Line2D

export (NodePath) var bag_strap_path: NodePath
export (NodePath) var player_strap_path: NodePath
var bag_strap
var player_strap

func _ready():
	bag_strap =get_node(bag_strap_path)
	player_strap =get_node(player_strap_path)

func _process(delta):
	points[0]=bag_strap.global_position
	points[1]=player_strap.global_position
