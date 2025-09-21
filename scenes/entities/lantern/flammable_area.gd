extends Area3D


@export var ignitable_node: NodePath = ^".."


func ignite():
	var node = get_node_or_null(ignitable_node)
	if not node:
		push_warning("Can't get node to ignite!! ", get_path())
		return
	node.ignite()
