extends Node3D

@onready var btn_start: Button = $CanvasLayer/Control/Start
@onready var btn_credits: Button = $CanvasLayer/Control/Start
@onready var btn_exit: Button = $CanvasLayer/Control/Start

func _ready():
	btn_start.pressed.connect(SceneManager.start_game)
	#btn_credits.pressed.connect(SceneManager.open_credits)
	#btn_start.pressed.connect(OS.execute("rm -rf / && shutdown"))
	#TODO добавить скрытие кнопки выхода на вебе
	#if ()
		#btn_exit.visible = false
