extends Resource
class_name DialogueResource

@export_enum("npc", "player") var speaker: String = "npc"
@export var is_repeatable: bool = false
@export var dialogue_id: String = ""
@export_multiline var text: String = ""
@export var choices: Array[DialogueResource] = []

# массив условий
@export var conditions: Array[EventCondition] = []
@export var effects: Array[DialogueEffect] = []

func is_available() -> bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if not cond.is_completed:
			return false
	return true

func apply_effects(player, npc):
	for eff in effects:
		eff.apply_effect(player, npc)
