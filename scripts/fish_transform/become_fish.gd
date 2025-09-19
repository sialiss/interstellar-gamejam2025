class_name BecomeFish extends Node

@export var fish_scene: PackedScene = preload("uid://dkr0eaj8a7o2f")
@export var revolution_trigger: RevolutionTrigger

func _ready() -> void:
	revolution_trigger.triggered.connect(become_fish)

func become_fish():
	var entity = get_parent()
	var fish = fish_scene.instantiate()
	entity.get_parent().add_child(fish)
	fish.transform = entity.transform
	entity.queue_free()
