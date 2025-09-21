extends Node

func start_game():
	get_tree().change_scene_to_file("res://scenes/world/level/level.tscn")

func change_to_death_scene():
	get_tree().change_scene_to_file("res://scenes/menu/death/death.tscn")
