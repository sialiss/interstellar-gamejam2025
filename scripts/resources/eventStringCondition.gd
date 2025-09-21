extends EventCondition
class_name EventStringCondition

@export var type: String = ""
@export var data: String = ""

func _on_event_triggered(checktype = null, checkdata = null):
	if (checktype == type and checkdata == data) or (checktype == checkdata):
		is_completed = true
