class_name Grabbable extends RigidBody3D

const NORMAL_LAYER = 3
const GRABBED_LAYER = 7

var can_enlarge: bool = true
var do_shrink_back: bool = true
var do_unfreeze: bool = true

func grabbed():
	freeze = true
	set_collision_layer_value(NORMAL_LAYER, false)
	set_collision_layer_value(GRABBED_LAYER, true)


func ungrabbed():
	if do_unfreeze:
		freeze = false
	set_collision_layer_value(NORMAL_LAYER, true)
	set_collision_layer_value(GRABBED_LAYER, false)


func enlarge() -> void:
	if !can_enlarge:
		return
		
	var original_scale = scale
	var target_scale = scale * 2
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "scale", target_scale, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "rotation:y", rotation.y + TAU, 2.0)
	tween.tween_property(self, "position:y", position.y + 1.0, 1.0)  
	tween.tween_property(self, "position:y", position.y, 1.0).set_delay(1.0)  
	
	can_enlarge = false
	
	var timer = Timer.new()
	timer.wait_time = 15
	timer.timeout.connect(_shrink_back.bind(original_scale))
	add_child(timer)
	timer.start()

func _shrink_back(scale_to_shrink: Vector3) -> void:
	if !do_shrink_back:
		return
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", scale_to_shrink, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	can_enlarge = true
