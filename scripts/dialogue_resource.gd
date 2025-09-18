extends Resource
class_name DialogueResource
@export_enum("npc", "player") var speaker: String = "npc"
@export var text: String = ""
@export var choices: Array[DialogueResource]
