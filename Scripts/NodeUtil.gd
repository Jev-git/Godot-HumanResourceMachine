extends Node

func get_first_node_in_group(_sGroup: String):
	return get_tree().get_nodes_in_group(_sGroup)[0]
