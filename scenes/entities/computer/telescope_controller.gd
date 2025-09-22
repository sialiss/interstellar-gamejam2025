class_name TelescopeController extends Node


@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var min_angle = - TAU
@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var max_angle = TAU
@export_range(0.0, 360.0, 0.001, "radians_as_degrees") var y_step = deg_to_rad(1.0)
@export_range(0.0, 360.0, 0.001, "radians_as_degrees") var x_step = deg_to_rad(1.0)

@export_range(0.0, 360.0, 0.001, "degrees") var min_fov = 0.0
@export_range(0.0, 360.0, 0.001, "degrees") var max_fov = TAU
@export_range(0.0, 360.0, 0.001, "degrees") var zoom_step = deg_to_rad(1.0)

@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var target_y_min = 0.0
@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var target_y_max = TAU
@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var target_x_min = 0.0
@export_range(-360.0, 360.0, 0.001, "radians_as_degrees") var target_x_max = TAU
@export_range(-360.0, 360.0, 0.001, "degrees") var target_zoom_min = 0.0
@export_range(-360.0, 360.0, 0.001, "degrees") var target_zoom_max = TAU


@export var y_rotor: Node3D
@export var x_rotor: Node3D
@export var camera: Camera3D
@export var completion_animation: AnimationPlayer


var is_done := false


func move_up():
	if is_done: return
	x_rotor.rotation.x = clampf(
		x_rotor.rotation.x - x_step,
		min_angle,
		max_angle
	)
	try_complete()

func move_down():
	if is_done: return
	x_rotor.rotation.x = clampf(
		x_rotor.rotation.x + x_step,
		min_angle,
		max_angle
	)
	try_complete()

func move_left():
	if is_done: return
	y_rotor.rotation.y = wrapf(
		y_rotor.rotation.y + y_step,
		0,
		TAU
	)
	try_complete()

func move_right():
	if is_done: return
	y_rotor.rotation.y = wrapf(
		y_rotor.rotation.y - y_step,
		0,
		TAU
	)
	try_complete()

func zoom_in():
	if is_done: return
	camera.fov = clampf(
		camera.fov - zoom_step,
		min_fov,
		max_fov
	)
	try_complete()

func zoom_out():
	if is_done: return
	camera.fov = clampf(
		camera.fov + zoom_step,
		min_fov,
		max_fov
	)
	try_complete()

func try_complete():
	if is_done: return
	if y_rotor.rotation.y < target_y_min: return
	if y_rotor.rotation.y > target_y_max: return
	if x_rotor.rotation.x < target_x_min: return
	if x_rotor.rotation.x > target_x_max: return
	if camera.fov < target_zoom_min: return
	if camera.fov > target_zoom_max: return
	is_done = true
	completion_animation.play("scan")
	completion_animation.animation_finished.connect(on_completed)

func on_completed(_anim_name):
	print("meow")
	EventBus.trigger("Area", "observatory")
