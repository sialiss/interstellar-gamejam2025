extends Node

var completed_dialogues: Dictionary = {}

func _ready() -> void:
	EventBus.cycle_reset.connect(_reset)

func _reset():
	completed_dialogues.clear()

func mark_completed(id: String) -> void:
	if id != "":
		completed_dialogues[id] = true
		EventBus.trigger("dialogue", id)

func is_completed(id: String) -> bool:
	return id != "" and completed_dialogues.has(id)

func is_dialogue_available(dialogue: DialogueResource) -> bool:
	# Проверка: уже пройден или недоступен
	if !dialogue.is_available() or (is_completed(dialogue.dialogue_id) and !dialogue.is_repeatable):
		return false
	return true
