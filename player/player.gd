extends CharacterBody3D

# Скорость движения
@export var speed: float = 5.0
# Чувствительность мыши
@export var mouse_sensitivity: float = 0.002
# Скорость прыжка
@export var JUMP_VELOCITY: float = 4.5

# Переменные для управления камерой
var camera_angle: float = 0
var do_camera_move: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	# Захват мышки (как в арксе)
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			do_camera_move = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			do_camera_move = true
	
	# Респавн
	if Input.is_action_just_pressed("restart"):
		position = Vector3(0, 10, 0)
		do_camera_move = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

func _input(event):
	if event is InputEventMouseMotion and do_camera_move:
		# Вращение камеры по вертикали
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -1.5, 1.5)

func _physics_process(delta: float) -> void:
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
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
		
	# Применение движения
	move_and_slide()
