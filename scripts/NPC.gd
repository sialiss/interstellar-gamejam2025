# res://scripts/npc.gd
extends StaticBody3D
class_name NPC

@export var NPC_name: String = "NPC"
@export var dialogue: DialogueResource
@export var funny_sound: AudioStream = null
@export var sound_count: int = 64
var sound_length: float = 1.0 / 8.0 # каждый звук по 1/8 секунды

# имя action из Input Map
@export var interact_action: String = "interact"

# Узлы
@onready var area: Area3D = $InteractionArea
@onready var model_root: Node3D = $Model
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _player_in_range: Node = null
var _can_talking: bool = false
var _can_jumping: bool = false
var is_jumping: bool = false

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
	if (_player_in_range and Input.is_action_just_pressed(interact_action) and
	_player_in_range.can_move and !is_jumping):
		_start_interaction()

func _start_interaction() -> void:
	emit_signal("interaction_started", dialogue, self)

func end_interaction() -> void:
	emit_signal("interaction_ended", dialogue, self)

func start_talking(node: DialogueResource) -> void:
	var char_count = node.text.length()
	var play_count = char_count
	if char_count > 15:
		play_count = randi_range(10, min(15, char_count))

	start_jumping(play_count / 8.0)
	_can_talking = true
	_play_random_sounds()
	await get_tree().create_timer(play_count / 8.0).timeout
	if _can_talking:
		stop_talking()

func _play_random_sounds():
	if sound_count <= 0:
		return
	while _can_talking:
		var index = randi() % sound_count
		audio.stream = funny_sound
		audio.seek(float(index * sound_length))
		audio.play()
		#_stop_after_delay() - не работает как отдельная функция, надо ждать тут
		await get_tree().create_timer(sound_length).timeout
		audio.stop()

func _stop_after_delay():
	await get_tree().create_timer(sound_length).timeout
	audio.stop()

func stop_talking():
	_can_talking = false
	stop_jumping()

func start_jumping(time: float):
	_can_jumping = true
	var jump_duration = 0.25
	var jump_height = 0.25
	while time - jump_duration >= 0 and _can_jumping:
		await _jump(jump_height, jump_duration)
		time -= jump_duration

func stop_jumping():
	_can_jumping = false

func _jump(jump_height: float, jump_duration: float):
	if is_jumping: return
	is_jumping = true
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
	is_jumping = false
