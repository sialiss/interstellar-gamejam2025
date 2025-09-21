extends Resource
class_name EventCondition

@export var type: String = ""
@export var data: String = ""
var is_completed: bool = false

func _bind_to_bus():
	EventBus.event_triggered.connect(_on_event_triggered)

func _on_event_triggered(checktype = null, checkdata = null):
	if (checktype == type and checkdata == data) or (checktype == checkdata):
		is_completed = true
