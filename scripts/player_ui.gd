extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt

func _ready():
	prompt_label.visible = false

# Показать подсказку
func show_prompt(text: String) -> void:
	prompt_label.text = text
	prompt_label.visible = true

# Скрыть подсказку
func hide_prompt() -> void:
	prompt_label.visible = false
