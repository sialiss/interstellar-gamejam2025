extends RunePattern
class_name FireRune

func execute(player: Player) -> void:
	print("fire")

	var camera = player.get_node("Camera3D")

	var fire_particle_scene: PackedScene = preload("res://resources/runes/fire_rune/fire_particle.tscn")
	var fire_particle: Area3D = fire_particle_scene.instantiate()
	var direction: Vector3 = camera.global_transform.basis.z.normalized()
	player.add_sibling(fire_particle)
	
	fire_particle.global_position = camera.global_position - direction * 1.0
	if fire_particle.has_method("set_velocity"):
		fire_particle.set_velocity(-direction * 10.0)
