class_name DeathMenu extends Node

func _ready():
	EventBus.reset_cycle()
	SaveManager.reset_profile()

func restart_game():
	SceneManager.change_to_main_menu()
