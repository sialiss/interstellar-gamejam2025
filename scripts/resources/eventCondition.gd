extends Resource
class_name EventCondition

@export var event_bus: NodePath
var is_completed: bool = false

func bind_to_bus(scene_root: Node):
	if event_bus.is_empty():
		return
	var bus: Node = scene_root.get_node_or_null(event_bus)
	if bus:
		bus.event_triggered.connect(_on_event_triggered)

func _on_event_triggered(data = null):
	is_completed = true
