extends Area3D

func _on_area_body_entered(body):
	print(body.name)
	if body.name == "Player":
		EventBus.trigger("Area", "Cave")
