extends Control
class_name PlayerUI

@onready var prompt_label: Label = $InteractionPrompt
@onready var runes_ui = $RunesUI
@onready var next_button: Button = $RunesUI/Next
@onready var prev_button: Button = $RunesUI/Prev

var ui_enabled: bool = true
var is_notebook_open: bool = false
var current_page: int = 0
var pending_flash_runes: Array = []

func _ready():
	prompt_label.visible = false
	runes_ui.visible = false
	runes_ui_setup()
	show_pages(0)

	next_button.pressed.connect(next_pages)
	prev_button.pressed.connect(prev_pages)
	EventBus.rune_unlocked.connect(_on_rune_unlocked)

func runes_ui_setup():
	hide_name_and_content('Page1')
	hide_name_and_content('Page2')

func hide_name_and_content(page_name: String):
	var page = runes_ui.get_node(page_name)
	for node_name in ["name", "content"]:
	#for node_name in ["content"]:
		if page.has_node(node_name):
			var content = page.get_node(node_name)
			content.visible = false
			if node_name == "content":
				content.texture = null

func open_runes_ui():
	runes_ui.visible = true
	is_notebook_open = true
	current_page = 0
	show_pages(current_page)
	if pending_flash_runes.size() > 0:
		for rune in pending_flash_runes:
			var rune_index = RuneManager.rune_patterns.find(rune)
			if rune_index >= current_page and rune_index < current_page + 2:
				var page_id = "Page1" if rune_index % 2 == 0 else "Page2"
				var page = runes_ui.get_node(page_id)
				flash_page(page)
		pending_flash_runes.clear()

func close_runes_ui():
	runes_ui.visible = false
	is_notebook_open = false

func show_pages(start_index: int):
	var pages = ["Page1", "Page2"]

	for i in range(pages.size()):
		var page = runes_ui.get_node(pages[i])
		var rune_index = start_index + i

		if rune_index < RuneManager.rune_patterns.size():
			var rune: RunePattern = RuneManager.rune_patterns[rune_index]

			# Название
			var name_label: Label = page.get_node("name")
			name_label.text = rune.rune_name if rune.is_name_known else "???"
			name_label.visible = true
			# Картинка
			var content: TextureRect = page.get_node("content")
			content.texture = rune.image if rune.is_pattern_known else null
			content.visible = true
			# Анимация
			var tween = create_tween()
			page.modulate.a = 0.0
			page.visible = true
			tween.tween_property(page, "modulate:a", 1.0, 0.3)
		else:
			hide_name_and_content(pages[i])

func next_pages():
	current_page += 2
	if current_page >= RuneManager.rune_patterns.size():
		current_page = 0 # можно зациклить
	show_pages(current_page)

func prev_pages():
	current_page -= 2
	if current_page < 0:
		current_page = max(RuneManager.rune_patterns.size() - 2, 0)
	show_pages(current_page)

func _on_rune_unlocked(rune: RunePattern):
	if is_notebook_open:
		var rune_index = RuneManager.rune_patterns.find(rune)
		if rune_index >= current_page and rune_index < current_page + 2:
			show_pages(current_page)
			var page_id = "Page1" if rune_index % 2 == 0 else "Page2"
			var page = runes_ui.get_node(page_id)
			flash_page(page)
	else:
		if not pending_flash_runes.has(rune):
			pending_flash_runes.append(rune)

func flash_page(page: Control):
	var tween = create_tween()
	page.modulate = Color(1.5, 1.5, 0.5, 1.0)
	tween.tween_property(page, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("notebook"):
		if !runes_ui.visible: open_runes_ui()
		else: close_runes_ui()

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
