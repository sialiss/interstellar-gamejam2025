extends Control
class_name DialogueUI

@onready var npc_name_label: Label = $Panel/NPCname
@onready var dialogue_label: Label = $Panel/DialogueText
@onready var choices_container: VBoxContainer = $Panel/Choices
@onready var player: Player = $"../Player"

var _current_node: DialogueResource = null
var _current_npc: Node = null
var _current_buttons: Array[Button] = []

signal dialogue_finished(npc)
signal is_dialogue_mode(enabled)

func _ready() -> void:
	visible = false

func start_dialogue(root: DialogueResource, npc: Node) -> void:
	_current_node = root
	_current_npc = npc
	visible = true
	_show_node(root)
	is_dialogue_mode.emit(true)

func _show_node(node: DialogueResource) -> void:
	dialogue_label.text = node.text
	npc_name_label.text = str(_current_npc.NPC_name) if node.speaker == "npc" else "You"

	if node.speaker == "npc" and _current_npc.has_method("start_talking"):
		_current_npc.start_talking(node)

	for child in choices_container.get_children():
		child.queue_free()
	_current_buttons.clear()

	if node.speaker == "npc":
		if node.choices.is_empty():
			var btn = create_button(1, "Next")
			btn.pressed.connect(_on_end_pressed)
			choices_container.add_child(btn)
			_current_buttons.append(btn)
		elif node.choices.size() == 1 and node.choices[0].speaker == "npc":
			var btn = create_button(1, "Next")
			btn.pressed.connect(func(): _on_choice_selected(node.choices[0]))
			choices_container.add_child(btn)
			_current_buttons.append(btn)
		else:
			for choice in node.choices:
				var btn = create_button(node.choices.find(choice) + 1, choice.text)
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
	if _current_node.effects.size() > 0:
		for effect in _current_node.effects:
			choice.effects.append(effect)
	_current_node = choice
	_show_node(choice)

func stop_dialogue() -> void:
	_on_end_pressed()

func _on_end_pressed() -> void:
	if _current_node:
		_current_npc.mark_completed(_current_node.dialogue_id)
		_current_node.apply_effects(player, _current_npc)

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

func create_button(i, choice_name):
	var btn := Button.new()
	btn.text = "[%d] %s" % [i, choice_name]
	btn.clip_text = true
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	return btn
