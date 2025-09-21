extends Control
class_name DialogueUI

@onready var npc_name_label: Label = $Panel/NPCname
@onready var dialogue_label: Label = $Panel/DialogueText
@onready var choices_container: VBoxContainer = $Panel/Choices

var _current_node: DialogueResource = null
var _current_npc: Node = null
var _current_buttons: Array[Button] = []

signal dialogue_finished(npc)
signal is_dialogue_mode(enabled)

func _ready() -> void:
	visible = false

func get_available_dialogue(npc_dialogues: Array[DialogueResource]) -> DialogueResource:
	for dialogue in npc_dialogues:
		if DialogueManager.is_dialogue_available(dialogue):
			return dialogue
	return null

func choose_npc_dialogue(npc_dialogues: Array[DialogueResource], npc: Node) -> void:
	var story_dialogue: DialogueResource = null
	var repeatable_dialogue: DialogueResource = null
	for dialogue in npc_dialogues:
		if DialogueManager.is_dialogue_available(dialogue):
			if not dialogue.is_repeatable and story_dialogue == null:
				story_dialogue = dialogue
			elif dialogue.is_repeatable and repeatable_dialogue == null:
				repeatable_dialogue = dialogue
	# приоритет — сюжетный
	var root = story_dialogue if story_dialogue else repeatable_dialogue
	if root == null:
		return # нет доступных диалогов
	start_dialogue(root, npc)

func start_dialogue(root: DialogueResource, npc: Node) -> void:
	if not root.is_repeatable and DialogueManager.is_completed(root.dialogue_id):
		if root.choices.size() > 0:
			root = root.choices[0]
		else:
			return

	_current_node = root
	_current_npc = npc
	visible = true
	_show_node(root)
	is_dialogue_mode.emit(true)

func _show_node(node: DialogueResource) -> void:
	dialogue_label.text = node.text
	npc_name_label.text = str(_current_npc.name) if node.speaker == "npc" else "You"

	if node.speaker == "npc" and _current_npc.has_method("start_talking"):
		_current_npc.start_talking(node)

	for child in choices_container.get_children():
		child.queue_free()
	_current_buttons.clear()

	if node.speaker == "npc":
		if node.choices.is_empty():
			var close_btn := Button.new()
			close_btn.text = "Next"
			close_btn.pressed.connect(_on_end_pressed)
			choices_container.add_child(close_btn)
			_current_buttons.append(close_btn)
		else:
			for choice in node.choices:
				var btn := Button.new()
				var index = node.choices.find(choice) + 1
				btn.text = "[%d] %s" % [index, choice.text]
				btn.clip_text = true
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.pressed.connect(func(): _on_choice_selected(choice))
				choices_container.add_child(btn)
				_current_buttons.append(btn)

	elif node.speaker == "player":
		if node.choices.is_empty():
			_on_end_pressed()
		else:
			node.choices[0].dialogue_id = _current_node.dialogue_id
			_show_node(node.choices[0])

func _unhandled_input(event: InputEvent) -> void:
	if not visible or _current_buttons.size() == 0:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var key_number = event.keycode - KEY_1 + 1 # KEY_1 → 1, KEY_2 → 2 и т.д.
		if key_number >= 1 and key_number <= _current_buttons.size():
			_current_buttons[key_number - 1].pressed.emit()

func _on_choice_selected(choice: DialogueResource) -> void:
	_current_npc.stop_talking()
	choice.dialogue_id = _current_node.dialogue_id
	_current_node = choice
	_show_node(choice)

func stop_dialogue() -> void:
	_on_end_pressed()

func _on_end_pressed() -> void:
	if _current_node:
		DialogueManager.mark_completed(_current_node.dialogue_id)

	visible = false
	dialogue_finished.emit(_current_npc)
	_current_npc.stop_talking()
	if _current_npc and _current_npc.has_method("end_interaction"):
		_current_npc.end_interaction()
	_current_node = null
	_current_npc = null
	is_dialogue_mode.emit(false)

func is_current_npc(npc):
	if npc == _current_npc: return true
	else: return false
