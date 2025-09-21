class_name RebirthMenu extends Node

func _ready():
	EventBus.reset_cycle()

func restart_game():
	SceneManager.start_game()
