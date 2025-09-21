extends Resource
class_name EventCondition

var is_completed: bool = false

func _bind_to_bus():
	EventBus.event_triggered.connect(_on_event_triggered)

func _on_event_triggered(_checktype = null, _checkdata = null):
	is_completed = true
