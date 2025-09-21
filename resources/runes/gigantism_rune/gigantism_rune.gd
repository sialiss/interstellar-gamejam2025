extends RunePattern
class_name GigantismRune

@export var radius: float = 2.0

func execute(player: Player) -> void:
	print_debug("gigantism rune executed")
	var objects = player.get_tree().get_nodes_in_group("enlargable")
	for obj in objects:
		if obj.global_position.distance_to(player.global_position) <= radius:
			if obj.has_method("enlarge"):
				obj.enlarge()
