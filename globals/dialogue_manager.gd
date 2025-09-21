extends Node

var completed_dialogues: Dictionary = {}
#var active_triggers: Dictionary = {}

func mark_completed(id: String) -> void:
	if id != "":
		completed_dialogues[id] = true
		EventBus.trigger("dialogue", id)

func is_completed(id: String) -> bool:
	return id != "" and completed_dialogues.has(id)

#func set_trigger(trigger: String, value: bool = true) -> void:
	#active_triggers[trigger] = value

#func has_trigger(trigger: String) -> bool:
	#return active_triggers.get(trigger, false)

func is_dialogue_available(dialogue: DialogueResource) -> bool:
	# Проверка: уже пройден
	if !dialogue.is_available() or is_completed(dialogue.dialogue_id):
		return false
	return true
