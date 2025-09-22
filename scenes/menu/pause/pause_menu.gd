extends CanvasLayer


var stored_mouse_mode: Input.MouseMode


func _ready():
	%ContinueButton.pressed.connect(close)
	%QuitButton.pressed.connect(SceneManager.change_to_main_menu)
	tree_exiting.connect(close)
	hide()

func _input(event: InputEvent):
	if event.is_action_pressed("pause_menu"):
		toggle_pause()

func toggle_pause():
	if visible:
		close()
	else:
		open()

func open():
	show()
	get_tree().paused = true
	stored_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close():
	hide()
	get_tree().paused = false
	Input.mouse_mode = stored_mouse_mode
