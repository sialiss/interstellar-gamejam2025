extends Node


const save_file_location = "user://save.tres"


var profile: SaveProfile


func _ready() -> void:
	load_profile()


func load_profile():
	if FileAccess.file_exists(save_file_location):
		profile = ResourceLoader.load(save_file_location)
		return
	
	profile = SaveProfile.new()


func save_profile():
	ResourceSaver.save(profile, save_file_location)
