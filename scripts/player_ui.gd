extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt
var ui_enabled: bool = true

func _ready():
	prompt_label.visible = false

func _set_ui_enabled(disabled: bool) -> void:
	ui_enabled = !disabled
	visible = !disabled
	if disabled:
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
