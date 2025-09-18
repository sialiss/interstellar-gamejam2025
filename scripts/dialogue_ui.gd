# res://scripts/dialogue_ui.gd
extends Control
class_name DialogueUI

@onready var npc_name_label: Label = $Panel/NPCname
@onready var dialogue_label: Label = $Panel/DialogueText
@onready var choices_container: VBoxContainer = $Panel/Choices

var _current_node: DialogueResource = null
var _current_npc: Node = null
var _current_buttons: Array[Button] = []

signal dialogue_finished(npc)

func _ready() -> void:
	visible = false

func start_dialogue(root: DialogueResource, npc: Node) -> void:
	_current_node = root
	_current_npc = npc
	print(_current_node, _current_npc)
	visible = true
	_show_node(root)

func _show_node(node: DialogueResource) -> void:
	dialogue_label.text = node.text
	npc_name_label.text = _current_npc.name if node.speaker == "npc" else "You"

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
			_show_node(node.choices[0])

func _unhandled_input(event: InputEvent) -> void:
	if not visible or _current_buttons.size() == 0:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var key_number = event.keycode - KEY_1 + 1  # KEY_1 → 1, KEY_2 → 2 и т.д.
		if key_number >= 1 and key_number <= _current_buttons.size():
			_current_buttons[key_number - 1].emit_signal("pressed")

func _on_choice_selected(choice: DialogueResource) -> void:
	_current_node = choice
	if choice.choices.is_empty():
		_show_node(choice)
	else:
		_show_node(choice)

func _on_end_pressed() -> void:
	visible = false
	emit_signal("dialogue_finished", _current_npc)
	if _current_npc and _current_npc.has_method("end_interaction"):
		_current_npc.end_interaction()
	_current_node = null
	_current_npc = null
