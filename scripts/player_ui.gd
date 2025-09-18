extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt

func _ready():
	prompt_label.visible = false
	#var npc = get_node("../NPC")
	#npc.player_in_range.connect(Callable(self, "show_prompt"))
	#npc.hide_prompt.connect(Callable(self, "hide_prompt"))

# Показать подсказку
func show_prompt(text: String) -> void:
	prompt_label.text = text
	prompt_label.visible = true

# Скрыть подсказку
func hide_prompt() -> void:
	prompt_label.visible = false
