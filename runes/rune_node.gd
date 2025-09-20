extends Area2D

signal mouse_exited_in_direction(value: int)

var last_mouse_position: Vector2 = Vector2.ZERO
var is_mouse_inside: bool = false


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	is_mouse_inside = true
	last_mouse_position = get_global_mouse_position()

func _on_mouse_exited():
	is_mouse_inside = false
	var exit_position: Vector2 = get_global_mouse_position()
	var direction: int = self.get_direction_from_center(exit_position)
	mouse_exited_in_direction.emit(direction)

func _input(event):
	if event is InputEventMouseMotion and is_mouse_inside:
		last_mouse_position = event.global_position

func get_direction_from_center(exit_pos: Vector2) -> int:
	var center: Vector2 = global_position
	var relative_pos: Vector2 = exit_pos - center
	var angle: float = relative_pos.angle()

	if angle >= -PI/8 and angle < PI/8:
		return 0  # Восток
	elif angle >= PI/8 and angle < 3*PI/8:
		return 1  # Северо-Восток
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		return 2  # Север
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		return 3  # Северо-Запад
	elif angle >= 7*PI/8 or angle < -7*PI/8:
		return 4  # Запад
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		return 5  # Юго-Запад
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		return 6  # Юг
	elif angle >= -3*PI/8 and angle < -PI/8:
		return 7  # Юго-Восток
	return -1 # Неизвестно
