@tool
class_name Darkness extends GPUParticles3D


@export var emission_box_extents = Vector3(1.0, 1.0, 1.0): set = set_emission_box_extents


func set_emission_box_extents(value: Vector3):
	emission_box_extents = value
	process_material.emission_box_extents = emission_box_extents
	print(emission_box_extents)


func disable():
	emitting = false
