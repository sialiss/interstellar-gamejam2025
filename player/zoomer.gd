extends Node

@export var camera: Camera3D
@export var player: Player
@export var zoom_fov := 50.0
@export var zoom_mouse_sens_multiplier := 1.0
@export var zoom_duration := 1.0

@onready var normal_fov: float = camera.fov
@onready var normal_mouse_sens: float = player.mouse_sensitivity

var zoom_amount := 0.0
var tween: Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom"):
		set_zoom(true)
	elif event.is_action_released("camera_zoom"):
		set_zoom(false)

func set_zoom(is_zoom_pressed: bool):
	var target_zoom_amount := float(is_zoom_pressed)
	var duration: float = zoom_duration * abs(target_zoom_amount - zoom_amount)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(update_zoom, zoom_amount, target_zoom_amount, duration)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)

func update_zoom(new_zoom_amount: float):
	zoom_amount = new_zoom_amount
	
	var fov := lerpf(normal_fov, zoom_fov, zoom_amount)
	camera.fov = fov
	
	var zoom_mouse_sens := normal_mouse_sens * zoom_mouse_sens_multiplier
	var mouse_sensitivity := lerpf(normal_mouse_sens, zoom_mouse_sens, zoom_amount)
	player.mouse_sensitivity = mouse_sensitivity
