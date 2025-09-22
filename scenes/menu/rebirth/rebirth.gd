class_name RebirthMenu extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	EventBus.reset_cycle()

func restart_game():
	SceneManager.start_game()
