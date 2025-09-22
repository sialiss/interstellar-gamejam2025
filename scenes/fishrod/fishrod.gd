extends Item

@export var enlargment_coeff: float = 10.0

var can_enchant: bool = true
var was_enlarged: bool = true
var can_pickup: bool = false

func _ready() -> void:
	do_unfreeze = false
	can_be_stored = false
	$Area3D.body_entered.connect(_on_body_entered)

func enlarge() -> void:
	if !can_enlarge or was_enlarged:
		return
	
	var target_scale = scale * enlargment_coeff
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "scale", target_scale, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "rotation:y", rotation.y + TAU, 2.0)
	tween.tween_property(self, "position:y", position.y + 1.0, 1.0)  
	tween.tween_property(self, "position:y", position.y, 1.0).set_delay(1.0)  
	
	can_enlarge = false
	was_enlarged = true
	
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

func is_enlarged() -> bool:
	return was_enlarged
	
func _on_body_entered(body: Node) -> void:
	if can_pickup:
		hide_from_world()
	
