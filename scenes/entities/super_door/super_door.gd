extends Node3D


@export var opening_duration := 1.0

var is_open := false


func receive_input(value: bool):
	if is_open: return
	is_open = value

	if is_open:
		open()


func open():
	var tween := create_tween()
	tween.tween_property($Body, "position", $OpenPosition.position, opening_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
