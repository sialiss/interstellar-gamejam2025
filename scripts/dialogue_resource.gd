extends Resource
class_name DialogueResource
@export_enum("npc", "player") var speaker: String = "npc"
@export var is_repeatable: bool = false
@export var dialogue_id: String = ""
@export var triggers: Array[String] = []
@export var text: String = ""
@export var choices: Array[DialogueResource]
