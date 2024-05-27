class_name Gamefield
extends Node

signal event(name : StringName, data : Dictionary)

@onready var cards_holder : Node2D = get_node("Cards")
@onready var client_ui : ClientUI = get_parent().get_node("CLIENT-UI")

func _ready() -> void:
	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_gamefield_action)

func export_gamefield_state() -> GamefieldState:
	return null

func load_gamefield_state(_state: GamefieldState) -> void:
	pass

var _hovered_card : CardOnField = null
func get_hovered_card() -> CardOnField:
	return _hovered_card

func _process(_delta : float) -> void: #TODO: do this somewhere else. CardBehaviorProcessor?
	for card : CardOnField in cards_holder.get_children():
		ICardInstance.id(card).logic.process()

func _handle_gamefield_action(action : Action) -> void:
	if not action is GamefieldAction: return

	if action is CreatureSpawnAction:
		var spawn_action : CreatureSpawnAction = action as CreatureSpawnAction
		place_card(spawn_action.creature, spawn_action.position)
		return

# make panning strength a user setting
func place_card(card : CardOnField, position : Vector2) -> void:
	card.position = position

	self.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		card.logic.process_event(event_name, data)
	)
	card.mouse_entered.connect(
		func() -> void:
			_hovered_card = card
	)
	card.mouse_exited.connect(
		func() -> void:
			_hovered_card = null
	)

	IStatisticPossessor.id(card).set_statistic("just_placed", true)
	
	cards_holder.add_child(card, true)
	var ap : AudioStreamPlayer2D = AudioDispatcher.dispatch_positional_audio(card, "res://ast/sound/cardplace.tres")
	ap.panning_strength = 0.25


