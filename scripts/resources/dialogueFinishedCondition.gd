extends EventCondition
class_name DialogueFinishedCondition

@export var required_id: String = ""

func _on_event_triggered(data = null):
	if typeof(data) == TYPE_STRING and data == required_id:
		is_completed = true
