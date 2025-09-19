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
## Масса игрока, влияет на силу толкания физических объектов
@export var mass := 1.0

var can_move: bool = true

# Переменные для управления камерой
var camera_angle: float = 0
var do_camera_move: bool = true

var grabbed_item: Grabbable


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
	
	#TODO replace `can_move` with something else?
	if event.is_action_pressed("interact") and can_move:
		if ray.is_colliding():
			var entity = ray.get_collider()
			if entity.is_in_group("interactable") or entity.is_in_group("npc"):
				entity.interact()

	if event.is_action_pressed("grab"):
		if ray.is_colliding():
			var item = ray.get_collider()
			if item is Grabbable:
				grab(item)
	
	if event.is_action_released("grab"):
		ungrab()

func _physics_process(delta: float) -> void:
	if not can_move:
		return # игрок заморожен
	
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
	
	# Толкание предметов
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is not RigidBody3D:
			continue
		
		var push_direction := -collision.get_normal()
		var velocity_diff_in_direction = velocity.dot(push_direction) - collider.linear_velocity.dot(push_direction)
		velocity_diff_in_direction = max(0.0, velocity_diff_in_direction)
		var mass_ratio = min(1.0, mass / collider.mass)
		push_direction.y = 0
		var push_force = mass_ratio * 3.0 # ⚠️ magic number alert!
		collider.apply_impulse(
			push_direction * velocity_diff_in_direction * push_force,
			collision.get_position() - collider.global_position
		)
	
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

func grab(item: Grabbable):
	grabbed_item = item
	item.grabbed()
	%GrabTransform.remote_path = item.get_path()

func ungrab():
	if is_instance_valid(grabbed_item):
		grabbed_item.ungrabbed()
		grabbed_item = null
		%GrabTransform.remote_path = ^""
