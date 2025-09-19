extends MeshInstance3D

@export_range(0.0, 360.0, 0.001, "radians_as_degrees") var limit_angle = 360.0
@export var jitter_noise_texture: NoiseTexture2D
@export var jitter_speed := 1.0
@export var jitter_magnitude := 1.0

func _process(delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera: return
	look_at(camera.global_position, get_parent_node_3d().global_basis.y, true)
	rotation = rotation.limit_length(limit_angle)
	
	jitter_noise_texture.noise.offset.x += delta * jitter_speed
	var jitter = jitter_noise_texture.get_image().get_pixel(0,0)
	rotation.x += (jitter.r - 0.5) * jitter_magnitude
	rotation.y += (jitter.g - 0.5) * jitter_magnitude
