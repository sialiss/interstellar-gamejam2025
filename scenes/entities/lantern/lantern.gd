@tool
extends Node3D


signal ignited


@export var enabled := false: set = set_enabled


func set_enabled(value: bool):
	enabled = value
	
	if enabled:
		$AnimationPlayer.play("on")
	else:
		$AnimationPlayer.play("off")


func ignite():
	set_enabled(true)
	ignited.emit()
