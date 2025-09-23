extends Node3D

@onready var player_ui: PlayerUI = $Player/PlayerUI
@onready var dualogue_ui: DialogueUI = $DialogueUI
@onready var player: CharacterBody3D = $Player

@export var revolution_triggers: Array[RevolutionTrigger] = []
@export var npcs: Array[NPC] = []

var current_revolution = -1
#var dialogue_mode: bool = false

func _ready():
	# сигналы к методам UI
	player.show_prompt.connect(player_ui._on_show_prompt)
	player.show_timer_prompt.connect(player_ui._on_show_timer_prompt)
	player.hide_prompt.connect(player_ui._on_hide_prompt)
	dualogue_ui.is_dialogue_mode.connect(player_ui._set_ui_enabled)
	dualogue_ui.is_dialogue_mode.connect(player._on_dialogue_mode)
	#dualogue_ui.is_dialogue_mode.connect(self._switch_dialogue_mode)
	#npc.interaction_started.connect(self._on_npc_interaction_started)
	for npc in npcs:
		npc.interaction_started.connect(dualogue_ui.choose_npc_dialogue)

func trigger_revolution():
	current_revolution += 1
	print('current_revolution', current_revolution)
	EventBus.trigger("Revolution", str(current_revolution + 1))
	if current_revolution >= revolution_triggers.size() or current_revolution < 0:
		return

	var revolution_trigger := revolution_triggers[current_revolution]
	revolution_trigger.trigger()

func check_npc_fish_transformation(npc):
	if dualogue_ui.is_current_npc(npc):
		dualogue_ui.stop_dialogue()

#func _switch_dialogue_mode(value: bool):
	#dialogue_mode = value
