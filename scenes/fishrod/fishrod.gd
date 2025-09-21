extends Node3D

@export var enlargment_coeff: float = 10.0

var can_enlarge: bool = false
var can_enchant: bool = true

signal enchanted

func enlarge() -> void:
	if !can_enlarge:
		return
	
	var target_scale = scale * enlargment_coeff
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "scale", target_scale, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "rotation:y", rotation.y + TAU, 2.0)
	tween.tween_property(self, "position:y", position.y + 1.0, 1.0)  
	tween.tween_property(self, "position:y", position.y, 1.0).set_delay(1.0)  
	
	can_enlarge = false
	
func enchant() -> void:
	if !can_enchant:
		return
	enchanted.emit()
	# TODO
	can_enchant = false
