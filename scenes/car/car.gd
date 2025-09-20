extends VehicleBody3D

@export var max_steer = 0.8
@export var engine_power = 300
@export var brake_power = 50
@export var mouse_sensitivity = 0.002

@onready var car_camera: Camera3D = $CarCamera
@onready var seat = $SeatMarker

var is_active: bool = false
var driver: Player = null
var camera_rotation: Vector2 = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if !is_active:
		engine_force = 0
		brake = brake_power
		return

	steering = move_toward(steering, Input.get_axis("move_right", "move_left") * max_steer, delta * 2.5)

	var accel_input = Input.get_axis("move_forward", "move_backward")
	if accel_input == 0:
		engine_force = 0
		brake = brake_power
	else:
		engine_force = accel_input * engine_power
		brake = 0


func _input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed("interact"):
		exit_vehicle()

	if is_active and event is InputEventMouseMotion:
		camera_rotation.x = clamp(camera_rotation.x - event.relative.y * mouse_sensitivity, -1.2, 0.5)
		camera_rotation.y -= event.relative.x * mouse_sensitivity

		if car_camera:
			var basis1 = Basis(Vector3.UP, camera_rotation.y)  # поворот по горизонтали
			basis1 = basis1.rotated(basis1.x, camera_rotation.x)  # поворот по вертикали
			car_camera.global_transform.basis = basis1
			#car_camera.global_transform.origin = seat.global_transform.origin

func interact(player: Player):
	if !driver:
		enter_vehicle(player)

func enter_vehicle(player: Player):
	driver = player
	player.visible = false
	if player.has_method("set_process"):
		player.set_process(false)
	if player.has_method("set_physics_process"):
		player.set_physics_process(false)

	player.global_transform = seat.global_transform

	if player.has_node("Camera3D"):
		player.get_node("Camera3D").current = false
	car_camera.current = true

	is_active = true

func exit_vehicle():
	engine_force = 0
	brake = brake_power

	if driver:
		# возвращаем игрока на позицию рядом с машиной
		var exit_point = $ExitMarker
		driver.global_transform.origin = exit_point.global_transform.origin

		driver.visible = true
		if driver.has_method("set_process"):
			driver.set_process(true)
		if driver.has_method("set_physics_process"):
			driver.set_physics_process(true)
		if driver.has_node("Camera3D"):
			driver.get_node("Camera3D").current = true
		car_camera.current = false

		driver = null
	is_active = false
	engine_force = 0
	brake = brake_power
