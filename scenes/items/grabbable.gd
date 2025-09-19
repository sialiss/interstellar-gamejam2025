class_name Grabbable extends RigidBody3D

func grabbed():
	freeze = true

func ungrabbed():
	freeze = false
