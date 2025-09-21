extends Node


const save_file_location = "user://save.tres"


@export var debug_dont_save = false


var profile: SaveProfile


func _ready() -> void:
	load_profile()

	EventBus.rune_unlocked.connect(on_rune_unlocked)


func load_profile():
	if FileAccess.file_exists(save_file_location):
		profile = ResourceLoader.load(save_file_location)
		return
	
	load_default_profile()


func load_default_profile():
	profile = SaveProfile.new()


func save_profile():
	if debug_dont_save and OS.is_debug_build(): return
	ResourceSaver.save(profile, save_file_location)


func reset_profile():
	load_default_profile()
	
	for rune_pattern in RuneManager.rune_patterns:
		rune_pattern.is_name_known = false
		rune_pattern.is_pattern_known = false
	
	EventBus.reset_cycle()


func on_rune_unlocked(rune: RunePattern):
	profile.store_rune(rune)
	save_profile()


func unlock_known_runes():
	for rune_pattern in RuneManager.rune_patterns:
		profile.restore_rune(rune_pattern)
