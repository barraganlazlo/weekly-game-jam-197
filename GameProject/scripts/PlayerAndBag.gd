extends Node2D
class_name PlayerAndBag

export(NodePath) var player_path
export(NodePath) var bag_path
export(NodePath) var line_path

func get_player():
	return get_node(player_path)

func get_bag():
	return get_node(bag_path)
