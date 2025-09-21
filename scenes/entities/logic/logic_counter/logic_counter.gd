class_name LogicCounter extends Node


signal output_changed(value: bool)


@export var inputs_required_to_activate = 1


var is_active := false
var counter := 0


func receive_input(value: bool):
	if value:
		counter += 1
	else:
		counter -= 1
	var new_active: bool = counter >= inputs_required_to_activate
	if is_active == new_active: return

	is_active = new_active
	output_changed.emit(is_active)
