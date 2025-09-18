extends Node3D

@onready var player_ui: PlayerUI = $Player/PlayerUI
@onready var dualogue_ui: DialogueUI = $DialogueUI
@onready var npc: NPC = $NPC
@onready var player: CharacterBody3D = $Player

func _ready():
	# сигналы к методам UI
	player.connect("show_prompt", Callable(player_ui, "_on_show_prompt"))
	#player.connect("show_timer_prompt", Callable(player_ui, "_on_show_timer_prompt"))
	player.connect("hide_prompt", Callable(player_ui, "_on_hide_prompt"))
	npc.connect("show_timer_prompt", Callable(player_ui, "_on_show_timer_prompt"))
	npc.connect("hide_prompt", Callable(player_ui, "_on_hide_prompt"))
	dualogue_ui.connect("set_player_ui_enabled", Callable(player_ui, "set_ui_enabled"))
	#npc.connect("interaction_started", Callable(self, "_on_npc_interaction_started"))
	npc.interaction_started.connect(
		func(dialogue, npc_ref):
			dualogue_ui.start_dialogue(dialogue, npc_ref)
	)
