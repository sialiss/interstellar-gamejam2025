# res://scripts/npc.gd
extends StaticBody3D
class_name NPC

@export var NPC_name: String = "NPC"
@export var dialogue: DialogueResource
@export var funny_sound: AudioStream = null
@export var sound_count: int = 64
var sound_length: float = 1.0 / 8.0 # каждый звук по 1/8 секунды

@export var jump_height: float = 0.25
@export var jump_duration: float = 0.25

# имя action из Input Map
@export var interact_action: String = "interact"

# Узлы
@onready var area: Area3D = $InteractionArea
@onready var model_root: Node3D = $Model
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _player_in_range: Node = null

signal interaction_started(dialogue, npc)
signal interaction_ended(dialogue, npc)

func _ready() -> void:
	area.body_entered.connect(Callable(self, "_on_area_body_entered"))
	area.body_exited.connect(Callable(self, "_on_area_body_exited"))

func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_in_range = body
		#emit_signal("player_in_range", "E - talk")

func _on_area_body_exited(body: Node) -> void:
	if body == _player_in_range:
		_player_in_range = null

func _process(_delta: float) -> void:
	if _player_in_range and Input.is_action_just_pressed(interact_action) and _player_in_range.can_move:
		_start_interaction()

func _start_interaction() -> void:

	# анимация (её нет и она не работает)
	#var anim_node = model_root.find_node("AnimationPlayer", true, false)
	#if anim_node and anim_node is AnimationPlayer:
		#if anim_node.has_animation("talk"):
			#anim_node.play("talk")

	emit_signal("interaction_started", dialogue, self)


func end_interaction() -> void:
	#var anim_node = model_root.find_node("AnimationPlayer", true, false)
	#if anim_node and anim_node is AnimationPlayer:
		#if anim_node.has_animation("idle"):
			#anim_node.play("idle")
	emit_signal("interaction_ended", dialogue, self)

func play_random_sound():
	if sound_count <= 0:
		return
	var index = randi() % sound_count
	audio.stream = funny_sound
	audio.seek(float(index * sound_length))
	audio.play()
	_stop_after_delay()

func _stop_after_delay():
	await get_tree().create_timer(sound_length).timeout
	audio.stop()

func jump(time: float):
	while time - jump_duration >= 0:
		await _start_jump()
		time -= jump_duration

func _start_jump():
	var start_y = position.y
	var peak_y = start_y + jump_height
	var half_time = jump_duration / 2.0

	# подъем
	var t = 0.0
	while t < half_time:
		var delta = get_process_delta_time()
		t += delta
		position.y = lerp(start_y, peak_y, t / half_time)
		await get_tree().process_frame

	# спадание
	t = 0.0
	while t < half_time:
		var delta = get_process_delta_time()
		t += delta
		position.y = lerp(peak_y, start_y, t / half_time)
		await get_tree().process_frame

	position.y = start_y
