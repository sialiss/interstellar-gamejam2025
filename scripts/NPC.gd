# res://scripts/npc.gd
extends Node3D
class_name NPC

@export var NPC_name: String = "NPC"
@export var dialogue: DialogueResource

# имя action из Input Map
@export var interact_action: String = "interact"
@export var prompt_text: String = "E - talk"
@export var player_node: Node3D

# Узлы
@onready var area: Area3D = $InteractionArea
@onready var model_root: Node3D = $Model

var _player_in_range: Node = null

signal player_in_range(prompt_text)
signal hide_prompt()
signal interaction_started(dialogue, npc)
signal interaction_ended(dialogue, npc)

func _ready() -> void:
	area.body_entered.connect(Callable(self, "_on_area_body_entered"))
	area.body_exited.connect(Callable(self, "_on_area_body_exited"))

func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_in_range = body
		emit_signal("player_in_range", "E - talk")

func _on_area_body_exited(body: Node) -> void:
	if body == _player_in_range:
		_player_in_range = null
		emit_signal("hide_prompt")

func _process(_delta: float) -> void:
	if _player_in_range and Input.is_action_just_pressed(interact_action):
		_start_interaction()

func _start_interaction() -> void:

	# анимация (её нет и она не работает)
	#var anim_node = model_root.find_node("AnimationPlayer", true, false)
	#if anim_node and anim_node is AnimationPlayer:
		#if anim_node.has_animation("talk"):
			#anim_node.play("talk")

	emit_signal("hide_prompt")
	emit_signal("interaction_started", dialogue, self)

func end_interaction() -> void:
	#var anim_node = model_root.find_node("AnimationPlayer", true, false)
	#if anim_node and anim_node is AnimationPlayer:
		#if anim_node.has_animation("idle"):
			#anim_node.play("idle")
	emit_signal("interaction_ended", dialogue, self)
