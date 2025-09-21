extends Resource
class_name RunePattern

@export var rune_name: String
@export var directions_array: Array[int] # 0 - право, 2 - низ, 4 - лево, 6 - верх. 1, 3, 5, 7 - диагонали. Переделать на енамы.
@export var image: CompressedTexture2D
var is_name_known: bool = false
var is_pattern_known: bool = false

# Это наследуемый класс. При создании новой руны наследуйте его и добавляйте логику руны в execute
func execute(_parent_node: Player) -> void:
	push_error("Execute not implemented in " + resource_path)
