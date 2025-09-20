extends Control

@export var icon: SceneTexture

@onready var inventory = $"../Inventory"
@onready var grid = $GridContainer

func _ready():
	inventory.inventory_changed.connect(update_slots)
	update_slots()

func update_slots():
	for child in grid.get_children():
		child.queue_free()
	for i in inventory.slots.size():
		var another_icon = icon.duplicate()
		another_icon.scene = get_scene_from_path(inventory.slots[i].scene_file_path)
		another_icon.bake()

		var btn = TextureButton.new()
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		another_icon.bake_finished.connect(func():
			btn.texture_normal = another_icon
			#var img = another_icon.get_render_image()
			#var path = "res://assets/icons/%s.png" % inventory.slots[i].name
			#img.save_png(path)
			#print("Saved icon to:", path)
		)
		btn.pressed.connect(func(): _on_slot_pressed(i))

		grid.add_child(btn)

func _on_slot_pressed(index: int):
	get_parent().unstore(index)

func get_scene_from_path(scene_file: String) -> PackedScene:
	var scene_res = load(scene_file)
	if scene_res and scene_res is PackedScene:
		return scene_res
	push_error("Failed to load scene: %s" % scene_file_path)
	return null
