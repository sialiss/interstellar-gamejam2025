extends Area3D

@export var music: AudioStream
@export var corrupted_music: AudioStream
@export var condition: EventStringCondition

func _ready():
	if condition: condition._bind_to_bus()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and music:
		if (condition.is_completed and corrupted_music):
			MusicManager.play_music(self.name, corrupted_music)
		else:
			MusicManager.play_music(self.name, music)
