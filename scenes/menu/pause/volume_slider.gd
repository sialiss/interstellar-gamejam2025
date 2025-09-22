extends HSlider

@export var audio_bux_idx = 0


func _ready():
	value = AudioServer.get_bus_volume_linear(audio_bux_idx)
	value_changed.connect(update_volume)
	drag_ended.connect(on_drag_ended)

func update_volume(volume: float):
	AudioServer.set_bus_volume_linear(audio_bux_idx, volume)

func on_drag_ended(did_value_change: bool):
	if not did_value_change: return
	SaveManager.save_setting("volume", value)
