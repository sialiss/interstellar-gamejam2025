extends Node3D

@onready var player_ui: PlayerUI = $PlayerUI
@onready var dualogue_ui: DialogueUI = $DialogueUI
@onready var npc: NPC = $NPC

func _ready():
	# сигналы NPC к методам UI
	npc.connect("player_in_range", Callable(player_ui, "show_prompt"))
	npc.connect("hide_prompt", Callable(player_ui, "hide_prompt"))
	#npc.connect("interaction_started", Callable(self, "_on_npc_interaction_started"))
	npc.interaction_started.connect(
		func(dialogue, npc_ref):
			dualogue_ui.start_dialogue(dialogue, npc_ref)
	)
