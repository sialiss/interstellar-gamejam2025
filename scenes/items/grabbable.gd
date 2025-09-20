class_name Grabbable extends RigidBody3D

const NORMAL_LAYER = 3
const GRABBED_LAYER = 7

func grabbed():
	freeze = true
	set_collision_layer_value(NORMAL_LAYER, false)
	set_collision_layer_value(GRABBED_LAYER, true)


func ungrabbed():
	freeze = false
	set_collision_layer_value(NORMAL_LAYER, true)
	set_collision_layer_value(GRABBED_LAYER, false)
