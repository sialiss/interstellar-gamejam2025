class_name BigFish extends Node3D

signal revolutioned

@onready var state_manager: StateManager = $StateManager
@onready var fish: Node3D = $Fish

@export var kill_turn_duration := 1.0
@export var bullet_scene: PackedScene
@export var kill_trigger: RevolutionTrigger

func _ready() -> void:
	state_manager.set_state(NormalState.new())
	if kill_trigger:
		kill_trigger.triggered.connect(enter_kill_state)

func _emit_revolutioned():
	revolutioned.emit()

func enter_kill_state():
	state_manager.set_state(KillTurnState.new())

func shoot_bullet():
	var bullet: Node3D = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_transform = %MuzzlePoint.global_transform

func stop_spinning():
	$SpinAnimationPlayer.stop(true)
func pause_spinning():
	$SpinAnimationPlayer.pause()
func resume_spinning():
	$SpinAnimationPlayer.play()


class BigFishState extends State:
	var host: BigFish

	func get_player() -> Node3D:
		var player_nodes := get_tree().get_nodes_in_group("player")
		var player: Node3D = player_nodes.get(0)
		return player

class NormalState extends BigFishState:
	func _input(event: InputEvent) -> void:
		if event is InputEventKey and event.keycode == KEY_K:
			host.enter_kill_state()

class KillTurnState extends BigFishState:
	var turn_progress := 0.0
	var current_transform: Transform3D
	var current_quat: Quaternion

	func _ready():
		host.stop_spinning()
		current_transform = host.fish.global_transform
		current_quat = Quaternion(current_transform.basis.orthonormalized())

	func _process(delta: float):
		turn_progress += delta / host.kill_turn_duration

		var player := get_player()

		var target_transform := current_transform.looking_at(player.global_position, Vector3.UP, true)
		var target_quat := target_transform.basis.get_rotation_quaternion()

		var new_quat := current_quat.slerp(target_quat, turn_progress)
		var new_rotation := new_quat.get_euler(host.fish.rotation_order)
		host.fish.global_rotation = new_rotation

		if turn_progress >= 1.0:
			host.state_manager.set_state(KillShootState.new())

class KillShootState extends BigFishState:
	func _ready() -> void:
		host.get_node(^"AnimationPlayer").play("kill")

	func _process(_delta: float) -> void:
		var player := get_player()
		host.fish.look_at(player.global_position, Vector3.UP, true)
