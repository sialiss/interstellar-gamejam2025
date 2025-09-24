extends Control

@export var magic_particle: Texture

var last_direction: int
var returned_directions: Array[int] = []
var current_rune_node: Area2D = null
var is_mouse_pressed: bool = false

static var rune_direction_controller_scene: PackedScene = preload("res://scripts/resources/runes/rune_node.tscn")

var can_paint_runes: bool = false

func _input(event: InputEvent) -> void:
	if can_paint_runes:
		calculate_direction(event)

func set_runes_enabled(enabled: bool):
	can_paint_runes = enabled

func paint_magic_particles() -> void:
	var camera: Camera3D = get_parent().get_node("Camera3D") as Camera3D
	if not camera:
		push_error("Player's camera not found!")

	var mouse_pos: Vector2 = get_global_mouse_position()
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var direction: Vector3 = camera.project_ray_normal(mouse_pos)

	create_particle(from + direction * 2)


# todo: Переделать частицы!
func create_particle(pos: Vector3):
	var sprite = Sprite3D.new()
	sprite.texture = magic_particle
	sprite.pixel_size = 0.01
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.position = pos
	sprite.modulate = Color.WHEAT
	get_tree().current_scene.add_child(sprite)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.01, 0.01, 0.01), 3.0)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 3.0)
	tween.tween_callback(sprite.queue_free)


func calculate_direction(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				is_mouse_pressed = true
				spawn_rune_direction_detector()
			if event.is_released():
				is_mouse_pressed = false
				cast_rune()

	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventMouseMotion and is_mouse_pressed):
		paint_magic_particles()


func cast_rune() -> void:
	var rune: RunePattern = RuneManager.find_matching_rune_pattern(returned_directions)
	if rune:
		var player: Player = get_parent() as Player
		if not player:
			push_error("Player is not found")
		rune.execute(player)
		MusicManager.play_rune_sound()
	else:
		pass

	# cleanup
	returned_directions = []
	if current_rune_node:
		current_rune_node.queue_free()
		current_rune_node = null


func spawn_rune_direction_detector() -> void:
	# Удалить предыдущую область
	if current_rune_node:
		current_rune_node.queue_free()
		current_rune_node = null

	# Создать новую область
	current_rune_node = rune_direction_controller_scene.instantiate()
	current_rune_node.position = get_global_mouse_position()
	add_sibling(current_rune_node)
	if current_rune_node.has_signal("mouse_exited_in_direction"):
		current_rune_node.mouse_exited_in_direction.connect(_on_rune_detector_exited)


# Добавить направление в массив, когда мышка двигается в направлении
func _on_rune_detector_exited(value: int) -> void:
	if ((returned_directions.size() == 0 or returned_directions.get(returned_directions.size() - 1) != value)
	and last_direction == value):
		returned_directions.append(value)
	# Удалить предыдущий детектор и создать новый
	last_direction = value
	if current_rune_node:
		current_rune_node.queue_free()
		current_rune_node = null
	spawn_rune_direction_detector()
	print('returned_directions', returned_directions)
