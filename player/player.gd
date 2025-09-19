class_name Player extends CharacterBody3D

signal show_prompt(prompt_text)
#signal show_timer_prompt(prompt_text)
signal hide_prompt()

@onready var ray: RayCast3D = %InteractionRay

## Скорость движения
@export var speed: float = 5.0
## Скорость бега
@export var run_speed: float = 10.0
## Чувствительность мыши
@export var mouse_sensitivity: float = 0.002
## Скорость прыжка
@export var JUMP_VELOCITY: float = 4.5

var can_move: bool = true

# Переменные для управления камерой
var camera_angle: float = 0
var do_camera_move: bool = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	# Захват мышки (как в арксе)
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_mouse_capture()
	
	# Респавн
	if Input.is_action_just_pressed("restart"):
		position = Vector3(0, 10, 0)
		_set_mouse_capture(true)
	
	if event is InputEventMouseMotion and do_camera_move:
		# Вращение камеры по вертикали
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -1.5, 1.5)

func _process(_delta: float):
	# Подсказка при наведении на объект
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.is_in_group("interactable"):
			show_prompt.emit("[E] - interact")
		elif obj.is_in_group("npc"):
			show_prompt.emit("[E] - talk")
		else:
			hide_prompt.emit()
	else:
		hide_prompt.emit()

func _physics_process(delta: float) -> void:
	if not can_move:
		return # игрок заморожен
	
	# Рассчёт скорости в падении
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Прыжок
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Управление движением
	var direction: Vector3 = Vector3.ZERO # todo: сейчас не сохраняет инерцию
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	# Нормализация направления и применение скорости
	direction = direction.normalized()
	var target_speed = speed
	if Input.is_action_pressed("move_run"):
		target_speed = run_speed
	velocity.x = direction.x * target_speed
	velocity.z = direction.z * target_speed
	
	# Применение движения
	move_and_slide()

func _on_dialogue_mode(is_dialogue_mode: bool):
	can_move = !is_dialogue_mode

func _toggle_mouse_capture():
	var should_capture := Input.mouse_mode == Input.MOUSE_MODE_VISIBLE
	_set_mouse_capture(should_capture)

func _set_mouse_capture(value: bool):
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		do_camera_move = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		do_camera_move = false
