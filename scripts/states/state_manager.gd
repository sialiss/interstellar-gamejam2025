class_name StateManager extends Node

var host: Node

var current_state: State

func _enter_tree() -> void:
	host = get_parent()

func set_state(new_state: State):
	if is_instance_valid(current_state):
		current_state.exit()
		current_state.queue_free()

	current_state = new_state
	new_state.host = host
	add_child(new_state)
