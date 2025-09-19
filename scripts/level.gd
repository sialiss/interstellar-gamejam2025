extends Node3D

@onready var player_ui: PlayerUI = $Player/PlayerUI
@onready var dualogue_ui: DialogueUI = $DialogueUI
@onready var npc: NPC = $NPC
@onready var player: CharacterBody3D = $Player

@export var revolution_triggers: Array[RevolutionTrigger] = []

var current_revolution = -1

func _ready():
	# сигналы к методам UI
	player.show_prompt.connect(player_ui._on_show_prompt)
	#player.show_timer_prompt.connect(player_ui._on_show_timer_prompt)
	player.hide_prompt.connect(player_ui._on_hide_prompt)
	dualogue_ui.is_dialogue_mode.connect(player_ui._set_ui_enabled)
	dualogue_ui.is_dialogue_mode.connect(player._on_dialogue_mode)
	#npc.interaction_started.connect(self._on_npc_interaction_started)
	npc.interaction_started.connect(dualogue_ui.start_dialogue)

func trigger_revolution():
	current_revolution += 1
	if current_revolution >= revolution_triggers.size() or current_revolution < 0:
		return

	var revolution_trigger := revolution_triggers[current_revolution]
	revolution_trigger.trigger()
