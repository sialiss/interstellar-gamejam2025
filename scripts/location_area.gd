extends Area3D

@export var music: AudioStream

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and music:
		MusicManager.play_music(self.name, music)
