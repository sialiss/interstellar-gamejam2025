extends Area3D

@export var speed: float = 10.0
@export var damage: int = 10

var initial_position: Vector3
var velocity: Vector3 = Vector3.ZERO

func _ready():
	initial_position = global_position
	body_entered.connect(_on_entered)
	area_entered.connect(_on_entered)
	
	var timer = Timer.new()
	timer.wait_time = 10
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()
	
func set_velocity(direction: Vector3):
	velocity = direction.normalized() * speed
	

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_entered(body):
	if body.is_in_group("flammable") && body.has_method("ignite"):
		body.ignite()
		queue_free()
	if body != self:
		print_debug("not flammable")
		queue_free()
