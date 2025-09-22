extends DialogueEffect
class_name GiveItemEffect

@export var item_scene: PackedScene

func apply_effect(player, npc):
	if not item_scene:
		return

	var item: Item = item_scene.instantiate()
	if not (item is Item):
		push_error("Scene is not an Item!")
		return

	 #пробуем положить в инвентарь
	if player.inventory.has_space():
		item.hide_from_world()
		if player.inventory.add_item(item):
			return

	# если места нет — дропаем предмет рядом с NPC
	var drop_pos = npc.global_transform.origin + Vector3(0, 1, 1)
	item.show_in_world(drop_pos, npc.get_parent())
