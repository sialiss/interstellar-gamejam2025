extends VehicleBody3D

@export var max_steer = 0.5
@export var engine_power = 300
@export var brake_power = 1
@export var mouse_sensitivity = 0.002
@export var camera_smooth_speed = 8.0
@export var camera_follow_strength := 0.05

@onready var car_camera: Camera3D = $CarCamera
@onready var seat = $SeatMarker

var is_active: bool = false
var driver: Player = null
var camera_rotation: Vector3 = Vector3.ZERO

var target_rotation: Vector3 = Vector3.ZERO  # x = вверх/вниз, y = влево/вправо
var current_rotation: Vector3 = Vector3.ZERO

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

	#var car_yaw = global_transform.basis.get_euler().y
	#target_rotation.y = lerp_angle(target_rotation.y, car_yaw, camera_follow_strength)
	#current_rotation = current_rotation.lerp(target_rotation, camera_smooth_speed * delta)

	var car_euler = global_transform.basis.get_euler()
	#print(car_euler.z, " ", current_rotation.z, " ", target_rotation.z)
	# плавно выравниваем camera target_rotation по машине
	target_rotation.x = lerp_angle(target_rotation.x, car_euler.x, camera_follow_strength)
	target_rotation.y = lerp_angle(target_rotation.y, car_euler.y, camera_follow_strength)
	target_rotation.z = lerp_angle(target_rotation.z, car_euler.z, camera_follow_strength)

	# плавное приближение текущей камеры к цели
	current_rotation.x = lerp_angle(current_rotation.x, target_rotation.x, camera_smooth_speed * delta)
	current_rotation.y = lerp_angle(current_rotation.y, target_rotation.y, camera_smooth_speed * delta)
	current_rotation.z = lerp_angle(current_rotation.z, target_rotation.z, camera_smooth_speed * delta)

	if car_camera:
		var basis1 = Basis(Vector3.UP, current_rotation.y)
		#basis1 = basis1.rotated(basis1.x, current_rotation.x)
		car_camera.global_transform.basis = basis1

func _input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed("interact"):
		exit_vehicle()

	if is_active and event is InputEventMouseMotion:
		target_rotation.x = clamp(target_rotation.x - event.relative.y * mouse_sensitivity, -1.2, 0.5)
		target_rotation.y -= event.relative.x * mouse_sensitivity

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
	self.sleeping = false

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
	self.sleeping = true
	engine_force = 0
	brake = brake_power
