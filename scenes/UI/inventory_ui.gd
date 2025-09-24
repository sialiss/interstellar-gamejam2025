extends Node

@export var icon: SceneTexture

@onready var inventory = $"../../Inventory"
@onready var player = $"../.."
@onready var grid = $GridContainer

var label_settings = preload("res://scenes/UI/inventory_slot_number_settings.tres")

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
		var number = Label.new()
		number.text = str(i + 1)
		number.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		number.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		number.anchor_right = 1
		number.anchor_bottom = 1
		number.label_settings = label_settings
		btn.add_child(number)
		btn.pressed.connect(func(): _on_slot_pressed(i))

		grid.add_child(btn)

func _on_slot_pressed(index: int):
	player.unstore(index)

func _input(event):
	var key_event = event as InputEventKey
	if key_event and key_event.pressed and not key_event.echo:
		var slot_index = key_event.keycode - Key.KEY_1
		if slot_index >= 0 and slot_index < inventory.slots.size():
			_on_slot_pressed(slot_index)


func get_scene_from_path(scene_file: String) -> PackedScene:
	var scene_res = load(scene_file)
	if scene_res and scene_res is PackedScene:
		return scene_res
	push_error("Failed to load scene: %s" % scene_file_path)
	return null
