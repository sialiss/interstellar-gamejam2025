extends Item

@export var enlargment_coeff: float = 10.0

var can_enchant: bool = true
var was_enlarged: bool = false
var can_pickup: bool = false

func _ready() -> void:
	super ()
	# do_unfreeze = false
	can_be_stored = false
	# $Area3D.body_entered.connect(_on_body_entered)

func enlarge() -> void:
	if !can_enlarge or was_enlarged:
		return

	can_enlarge = false
	was_enlarged = true

	freeze = true
	$CollisionShape3D.disabled = true

	var target_scale = scale * enlargment_coeff
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($fishing_rod, "scale", target_scale, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "rotation:y", rotation.y + TAU, 2.0)
	tween.tween_property(self, "position:y", position.y + 10.0, 1.0)
	#tween.tween_property(self, "position:y", position.y, 1.0).set_delay(1.0)

	await tween.finished

	$CollisionShape3D2.disabled = false
	freeze = false
	can_pickup = false

	await get_tree().create_timer(1.0).timeout

	get_tree().get_nodes_in_group("player")[0].show_timer_prompt.emit(3, "the rod will now be attached to the rocket :)")
	get_tree().get_nodes_in_group("rocket")[0].attach_rod()
	queue_free()

func enchant() -> void:
	if !can_enchant:
		return
	EventBus.trigger("Rune", "enchantment_rune")
	can_enchant = false

func play_fishing_animation():
	var tween: Tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "rotation:y", rotation.y + TAU, 2.0)
	tween.tween_property(self, "position:y", position.y + 1.0, 1.0)
	tween.tween_property(self, "position:y", position.y, 1.0).set_delay(1.0)

func make_pickable():
	can_enlarge = true
	can_pickup = true
	set_collision_layer_value(3, true)

func is_enlarged() -> bool:
	return was_enlarged

# func _on_body_entered(body: Node) -> void:
# 	if can_pickup:
# 		hide_from_world()
