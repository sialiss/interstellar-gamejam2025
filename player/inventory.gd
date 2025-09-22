extends Node

signal inventory_changed

var slots: Array = []
var max_slots := 5

func add_item(item: Node):
	if has_space():
		slots.append(item)
		print(item)
		EventBus.trigger("Inventory", item.name)
		emit_signal("inventory_changed")
		return true
	return false

func remove_item(index: int) -> Node:
	if index >= 0 and index < slots.size():
		var removed = slots[index]
		slots.remove_at(index)
		emit_signal("inventory_changed")
		return removed
	return null

func has_space():
	if slots.size() < max_slots: return true
	return false
