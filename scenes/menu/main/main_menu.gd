extends Node3D

@onready var btn_start: Button = $CanvasLayer/Control/Start
@onready var btn_credits: Button = $CanvasLayer/Control/Credits
@onready var btn_exit: Button = $CanvasLayer/Control/Exit

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	btn_start.pressed.connect(SceneManager.start_game)
	#btn_credits.pressed.connect(SceneManager.open_credits)
	btn_exit.pressed.connect(get_tree().quit)
	#TODO добавить скрытие кнопки выхода на вебе
	#if ()
		#btn_exit.visible = false
