extends Area3D

@export var win_animation_player: AnimationPlayer

var is_rod_attached: bool = false

func _ready():
	$"../fishing_rod".visible = false
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("fishing_rod") and body.has_method("is_enlarged") and body.is_enlarged():
		body.queue_free()
		attach_rod()

func attach_rod():
	$"../fishing_rod".visible = true
	is_rod_attached = true
	print("rod was attached")

func ignite():
	if is_rod_attached:
		win_animation_player.play("win")
