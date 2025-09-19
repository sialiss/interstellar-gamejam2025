extends Node3D

@export var speed := 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $RayCast3D.is_colliding():
		set_physics_process(false)
		SceneManager.change_to_death_scene()
		return
	
	var direction = -basis.z.normalized()
	position += direction * speed * delta
