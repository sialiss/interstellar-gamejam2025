class_name Item extends Grabbable

@export var can_be_stored: bool = true
@export var item_name =  "item"
var is_in_inventory: bool = false

func _ready() -> void:
	self.add_to_group("items")

func hide_from_world():
	grabbed()
	visible = false
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true
	is_in_inventory = true
	if get_parent():
		get_parent().remove_child(self)

func show_in_world(pos: Vector3, parent: Node):
	ungrabbed()
	visible = true
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = false
	is_in_inventory = false
	parent.add_child(self)
	global_transform.origin = pos
