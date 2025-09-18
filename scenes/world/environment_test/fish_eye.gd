extends MeshInstance3D

@export_range(0.0, 360.0, 0.001, "radians_as_degrees") var limit_angle = 360.0

func _process(_delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera: return
	look_at(camera.global_position, get_parent_node_3d().global_basis.y, true)
	rotation = rotation.limit_length(limit_angle)
