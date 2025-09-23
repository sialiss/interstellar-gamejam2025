class_name BecomeFish extends Node3D

@export var fish_scene: PackedScene = preload("uid://dkr0eaj8a7o2f")
@export var revolution_triggers: Array[RevolutionTrigger]

signal becomes_fish(npc)

func _ready() -> void:
	var size = revolution_triggers.size()
	if size > 1:
		revolution_triggers.pick_random().triggered.connect(become_fish)
	else:
		revolution_triggers[0].triggered.connect(become_fish)

	becomes_fish.connect(get_tree().current_scene.check_npc_fish_transformation)

func become_fish():
	var entity = get_parent()
	becomes_fish.emit(entity)
	var fish = fish_scene.instantiate()
	entity.get_parent().add_child(fish)
	fish.global_transform = self.global_transform
	entity.queue_free()
