extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt
@onready var runes_ui = $RunesUI
var ui_enabled: bool = true

func _ready():
	prompt_label.visible = false
	runes_ui.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("notebook"):
		if !runes_ui.visible: runes_ui.visible = true
		else: runes_ui.visible = false

func _set_ui_enabled(disabled: bool) -> void:
	ui_enabled = !disabled
	visible = !disabled
	if disabled:
		prompt_label.visible = false

# Показать подсказкуно работаетно работает
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
