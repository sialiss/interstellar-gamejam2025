extends Node


const save_file_location = "user://save.tres"
const settings_file_location = "user://settings.tres"


@export var debug_dont_save = false


var profile: SaveProfile
var settings: Dictionary[String,Variant] = {}
var default_settings: Dictionary[String,Variant] = {
	volume = 1.0
}


func _ready() -> void:
	load_settings()
	load_profile()

	EventBus.rune_unlocked.connect(on_rune_unlocked)
	EventBus.cycle_reset.connect(on_rebirth_unlocked)

#region PROFILE

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


#endregion

#region SETTINGS
func load_settings():
	if not FileAccess.file_exists(settings_file_location):
		apply_settings(default_settings)
		return
	var file := FileAccess.open(settings_file_location, FileAccess.READ)
	settings = file.get_var()
	file.close()

	apply_settings(default_settings.merged(settings, true))

func save_setting(setting_name: String, value: Variant):
	settings[setting_name] = value

	var file := FileAccess.open(settings_file_location, FileAccess.WRITE)
	file.store_var(settings)
	file.close()

func apply_settings(settings_dict: Dictionary[String,Variant]):
	for setting_name in settings_dict:
		apply_setting(setting_name, settings_dict[setting_name])

func apply_setting(setting_name: String, value: Variant):
	match setting_name:
		"volume": AudioServer.set_bus_volume_linear(0, value)
#endregion

#region RUNES

func on_rune_unlocked(rune: RunePattern):
	profile.store_rune(rune)
	save_profile()

func unlock_known_runes():
	for rune_pattern in RuneManager.rune_patterns:
		profile.restore_rune(rune_pattern)

#endregion

#region PROGRESS

func on_rebirth_unlocked():
	profile.save_rebirth_progress()
	save_profile()

#endregion
