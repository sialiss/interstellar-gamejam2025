extends MeshInstance3D


func _ready() -> void:
	if (!SaveManager.profile.player_was_reborn):
		self.visible = false

func _on_cycle_reset():
	if (!SaveManager.profile.player_was_reborn):
		SaveManager.on_rebirth_unlocked()
		self.visible = true
