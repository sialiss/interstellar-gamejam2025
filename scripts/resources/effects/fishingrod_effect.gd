extends DialogueEffect
class_name animate_fishrod

func apply_effect(_player, _npc):
	EventBus.trigger("Inventory", "charmed_rod")
	var fishrod = _npc.get_node("fishrod")
	fishrod.can_enlarge = true
	fishrod.can_pickup = true
	await fishrod.play_fishing_animation()
	
