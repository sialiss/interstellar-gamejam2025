extends RunePattern
class_name TestRune

@export var texture: Texture2D
@export var sound_effect: AudioStream

# Это просто тестовая логика для тестовой руны, можно сюда что угодно писать
func execute(parent_node: Player) -> void:
	#print_debug("some logic in " + rune_name)
	var sprite = Sprite3D.new()
	sprite.texture = texture
	sprite.centered = true
	sprite.scale = Vector3(3, 3, 3)
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	parent_node.get_parent().add_child(sprite)
	sprite.global_position = parent_node.global_position + Vector3(0, 5, 0)

	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	timer.timeout.connect(_remove_sprite.bind(timer, sprite))
	sprite.add_child(timer)
	timer.start()

	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = sound_effect
	audio_player.finished.connect(audio_player.queue_free)
	parent_node.add_child(audio_player)
	audio_player.play()


func _remove_sprite(timer: Timer, sprite: Sprite3D) -> void:
	if is_instance_valid(sprite):
		sprite.queue_free()
		timer.queue_free()
	else:
		push_error("Что-то сломалось в тестовой руне")
