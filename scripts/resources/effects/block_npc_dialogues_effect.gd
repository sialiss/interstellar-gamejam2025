extends DialogueEffect
class_name BlockNpcDialoguesEffect

@export var allowed_dialogue: DialogueResource

func apply_effect(_player, npc):
	if allowed_dialogue:
		npc.block_dialogues.append(allowed_dialogue)
