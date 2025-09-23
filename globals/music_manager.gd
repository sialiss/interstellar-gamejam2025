extends Node

@onready var player_a: AudioStreamPlayer = $LocationAudio1
@onready var player_b: AudioStreamPlayer = $LocationAudio2
@onready var rune_player: AudioStreamPlayer = $RuneSound
@onready var birds_player: AudioStreamPlayer = $Birds
var active_player: AudioStreamPlayer
var inactive_player: AudioStreamPlayer

@export var fade_time: float = 1.0  # время плавного перехода

func _ready():
	active_player = player_a
	inactive_player = player_b

func play_music(location: String, stream: AudioStream):
	if active_player.stream == stream:
		return # уже играет эта музыка
	#print("music start", stream.resource_path)
	# второй плеер
	inactive_player.stop()
	inactive_player.stream = stream
	inactive_player.volume_db = -80
	inactive_player.play()

	if (location == "Forest2"):
		play_birds_sound()
	else:
		stop_birds_sound()
	# плавный переход
	var tween := create_tween()
	tween.parallel().tween_property(active_player, "volume_db", -80.0, fade_time)
	tween.parallel().tween_property(inactive_player, "volume_db", -20.0, fade_time)

	tween.finished.connect(_swap_players)

func _swap_players():
	var temp = active_player
	active_player = inactive_player
	inactive_player = temp
	inactive_player.stop()

func play_rune_sound():
	rune_player.play()

func play_birds_sound():
	birds_player.play()
	var tween := create_tween()
	tween.parallel().tween_property(birds_player, "volume_db", -20.0, fade_time)

func stop_birds_sound():
	birds_player.play()
	var tween := create_tween()
	tween.parallel().tween_property(birds_player, "volume_db", -80.0, fade_time)
	tween.finished.connect(birds_player.stop)
