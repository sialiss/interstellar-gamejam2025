class_name RuneDrawer2 extends Control

@export var player: Player
@export var magic_particle: Texture
@export var recent_directions_count_curve: Curve

@onready var state := StateManager.new()

func _ready() -> void:
	add_child(state)
	state.set_state(IdleState.new())


func set_runes_enabled(value: bool):
	if value:
		state.set_state(IdleState.new())
	else:
		state.set_state(DisabledState.new())


class DrawerState extends State:
	var host: RuneDrawer2


class DisabledState extends DrawerState:
	pass


class IdleState extends DrawerState:
	func _input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			host.state.set_state(DrawingState.new())


class DrawingState extends DrawerState:
	const recent_speed_count = 10

	# var raw_directions := PackedVector2Array()
	var recent_raw_directions := PackedVector2Array()
	var recent_speed_squared := PackedFloat32Array()

	var directions := PackedInt32Array()
	var direction_candidate := 0

	func _input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
			calculate_direction(event)
			paint_magic_particles()
		if event is InputEventMouse and event.button_mask & MOUSE_BUTTON_MASK_LEFT == 0:
			end_drawing()

	func calculate_direction(event: InputEventMouseMotion) -> void:
		# raw_directions.push_back(event.relative)
		# speed
		recent_speed_squared.push_back(event.velocity.length_squared())
		if recent_speed_squared.size() > recent_speed_count:
			recent_speed_squared = recent_speed_squared.slice(1)
		var average_speed = sqrt(average_float(recent_speed_squared))

		# direction
		recent_raw_directions.push_back(event.relative)
		var recent_directions_count = roundi(host.recent_directions_count_curve.sample_baked(average_speed))
		var average_angle = average_vector(recent_raw_directions).angle()
		var direction = angle_to_direction_enum(average_angle)
		if recent_raw_directions.size() > recent_directions_count:
			recent_raw_directions = recent_raw_directions.slice(1)
			if direction != direction_candidate:
				recent_raw_directions.clear()
				recent_speed_squared.clear()
				directions.push_back(direction_candidate)
		else:
			direction_candidate = direction

		print(direction, " ", direction_candidate, " ", directions)
	
	func angle_to_direction_enum(angle: float) -> int:
		return roundi(wrapf(angle, 0, TAU) / TAU * 8) % 8

	func average_float(numbers: PackedFloat32Array) -> float:
		var sum = 0
		for number in numbers:
			sum += number
		return sum / numbers.size()

	func average_vector(vectors: PackedVector2Array) -> Vector2:
		var sum := Vector2.ZERO
		for direction in vectors:
			sum += direction
		return sum / vectors.size()

	# https://www.desmos.com/calculator/ak6fbcdpgb
	func prioritize_diagonals(angle: float) -> float:
		var weight_power = 0.6
		var weight = pow((1 + cos(angle * 4 + PI)) / 2, weight_power)

		var weird_magic_number = 1.275
		var weird_magic_number_half = weird_magic_number * 0.5
		var diagonals = ceilf(angle * weird_magic_number_half) / weird_magic_number_half - TAU / 8

		return lerpf(angle, diagonals, weight)

	func end_drawing() -> void:
		set_process_input(false)
		directions.push_back(direction_candidate)
		print("---CAST--- ", directions)

		var rune := RuneManager.find_matching_rune_pattern(directions)
		if rune:
			rune.execute(host.player)
			MusicManager.play_rune_sound()
		elif directions.size() > 0:
			MusicManager.play_runefailure_sound()

		host.state.set_state(IdleState.new())
	
	func paint_magic_particles() -> void:
		var camera: Camera3D = host.player.get_node("Camera3D") as Camera3D
		if not camera:
			push_warning("Player's camera not found!")
			return

		var mouse_pos: Vector2 = host.get_global_mouse_position()
		var from: Vector3 = camera.project_ray_origin(mouse_pos)
		var direction: Vector3 = camera.project_ray_normal(mouse_pos)

		var position = from + direction * 2

		var sprite = Sprite3D.new()
		sprite.texture = host.magic_particle
		sprite.pixel_size = 0.01
		sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		sprite.position = position
		sprite.modulate = Color.WHEAT
		get_tree().current_scene.add_child(sprite)
		var tween = sprite.create_tween()
		tween.tween_property(sprite, "scale", Vector3(0.01, 0.01, 0.01), 3.0)
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 3.0)
		tween.tween_callback(sprite.queue_free)
