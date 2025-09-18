extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt
var ui_enabled: bool = true

func _ready():
	prompt_label.visible = false

func set_ui_enabled(enabled: bool) -> void:
	ui_enabled = enabled
	visible = enabled
	if not enabled:
		prompt_label.visible = false

# Показать подсказку
func _on_show_prompt(text: String) -> void:
	prompt_label.text = text
	prompt_label.visible = true

# Показать временную подсказку (наверху) (пока не работает)
func _on_show_timer_prompt(text: String) -> void:
	#prompt_label.text = text
	prompt_label.visible = true

# Скрыть подсказку
func _on_hide_prompt() -> void:
	prompt_label.visible = false
