extends Node

const MAIN_MENU_SCENE = "res://scenes/menu/main_menu.tscn"
const GAME_SCENE = "res://scenes/world/level/level.tscn"
const DEATH_SCENE = "res://scenes/menu/death/death.tscn"
const REBIRTH_SCENE = "res://scenes/menu/rebirth/rebirth.tscn"

const TIME_RUNE_UID = "uid://cmrgsajfpa3dh"

func start_game():
	get_tree().change_scene_to_file(GAME_SCENE)

func change_to_main_menu():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func change_to_death_scene():
	var time_rune: TimeRune = load(TIME_RUNE_UID)
	if time_rune.is_pattern_known:
		get_tree().change_scene_to_file(REBIRTH_SCENE)
	else:
		get_tree().change_scene_to_file(DEATH_SCENE)
