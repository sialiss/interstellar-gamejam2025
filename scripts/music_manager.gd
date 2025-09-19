extends Node

@onready var player_a: AudioStreamPlayer = $LocationAudio1
@onready var player_b: AudioStreamPlayer = $LocationAudio2
var active_player: AudioStreamPlayer
var inactive_player: AudioStreamPlayer

@export var fade_time: float = 2.0  # время плавного перехода

func _ready():
	active_player = player_a
	inactive_player = player_b

func play_music(stream: AudioStream):
	if active_player.stream == stream:
		return # уже играет эта музыка
	#print("music start")
	# второй плеер
	inactive_player.stop()
	inactive_player.stream = stream
	inactive_player.volume_db = -80
	inactive_player.play()

	# плавный переход (надеюсь работает)
	var tween := create_tween()
	tween.parallel().tween_property(active_player, "volume_db", -80.0, fade_time)
	tween.parallel().tween_property(inactive_player, "volume_db", -35.0, fade_time)

	tween.finished.connect(_swap_players)

func _swap_players():
	var temp = active_player
	active_player = inactive_player
	inactive_player = temp
