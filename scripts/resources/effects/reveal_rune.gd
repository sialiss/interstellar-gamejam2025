extends DialogueEffect
class_name RevealRuneEffect

@export var rune: RunePattern

func apply_effect(_player, _npc):
	if rune:
		EventBus.reveal_name(rune)
