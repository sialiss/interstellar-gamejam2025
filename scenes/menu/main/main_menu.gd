extends Node3D

@onready var btn_start: Button = $CanvasLayer/Menu/Start
@onready var btn_credits: Button = $CanvasLayer/Menu/Credits
@onready var btn_exit: Button = $CanvasLayer/Menu/Exit
@onready var btn_back: Button = $CanvasLayer/Credits/Back

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	btn_start.pressed.connect(SceneManager.start_game)
	btn_credits.pressed.connect(open_credits)
	btn_back.pressed.connect(open_menu)
	btn_exit.pressed.connect(get_tree().quit)
	hide_credits()
	if OS.get_name() == "HTML5":
		$btn_exit.visible = false

func open_menu():
	$CanvasLayer/Menu.visible = true
	hide_credits()

func hide_menu():
	$CanvasLayer/Menu.visible = false

func open_credits():
	$CanvasLayer/Credits.visible = true
	hide_menu()

func hide_credits():
	$CanvasLayer/Credits.visible = false
