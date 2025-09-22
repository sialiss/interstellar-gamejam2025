class_name TelescopeButton extends Area3D


signal interacted


func _ready():
	add_to_group(&"interactable", true)


func interact():
	interacted.emit()
