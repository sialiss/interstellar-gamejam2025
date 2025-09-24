extends Resource
class_name EventCondition

var is_completed: bool = false
var is_blocked: bool = false
@export var invert: bool = false

func _init() -> void:
	EventBus.cycle_reset.connect(_reset)

func _reset():
	is_completed = false

func _bind_to_bus():
	EventBus.event_triggered.connect(_on_event_triggered)

func _on_event_triggered(_checktype = null, _checkdata = null):
	if invert:
		is_completed = false
		is_blocked = true
	else:
		is_completed = true

func unblock():
	is_blocked = false
