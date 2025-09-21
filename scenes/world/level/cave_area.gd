extends Area3D

func _ready():
	self.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
	print(body.name)
	if body.name == "Player":
		EventBus.trigger("Area", "Cave")
