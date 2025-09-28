class_name SaveProfile extends Resource

@export var known_runes: Dictionary[String, Variant] = {}
@export var player_was_reborn: bool = false

func store_rune(rune: RunePattern):
	var uid := ResourceUID.path_to_uid(rune.resource_path)
	known_runes[uid] = {
		name = rune.is_name_known,
		pattern = rune.is_pattern_known
	}

func restore_rune(rune: RunePattern):
	var uid := ResourceUID.path_to_uid(rune.resource_path)
	if uid not in known_runes: return

	var rune_data = known_runes[uid]
	rune.is_name_known = rune_data.name
	rune.is_pattern_known = rune_data.pattern
	EventBus.trigger("Rune", rune.rune_name)

func save_rebirth_progress():
	player_was_reborn = true
