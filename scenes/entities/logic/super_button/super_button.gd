class_name SuperButton extends Node3D


signal output_changed(value: bool)


@onready var surface_body: AnimatableBody3D = $SurfaceBody
@onready var surface_area: Area3D = %SurfaceArea
@onready var surface_body_pressed_position: Node3D = $SurfaceBodyPressedPosition
@onready var surface_body_unpressed_position: Node3D = $SurfaceBodyUnpressedPosition


@export var pressing_duration = 1.0


var is_pressed := false: set = set_pressed
var pressed_counter := 0
var pressed_amount := 0.0
var tween: Tween


func _ready():
	surface_area.body_entered.connect(_on_body_entered)
	surface_area.body_exited.connect(_on_body_exited)


func _on_body_entered(_body: PhysicsBody3D):
	pressed_counter += 1
	is_pressed = pressed_counter > 0


func _on_body_exited(_body: PhysicsBody3D):
	pressed_counter -= 1
	is_pressed = pressed_counter > 0


func set_pressed(value: bool):
	if is_pressed == value: return

	is_pressed = value
	output_changed.emit(is_pressed)

	var target_pressed_amount := float(is_pressed)
	var duration: float = pressing_duration * abs(target_pressed_amount - pressed_amount)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(update_pressed_amount, pressed_amount, target_pressed_amount, duration) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)

func update_pressed_amount(new_pressed_amount: float):
	pressed_amount = new_pressed_amount
	
	var body_position := surface_body_unpressed_position.position.lerp(
		surface_body_pressed_position.position,
		pressed_amount
	)
	surface_body.position = body_position
