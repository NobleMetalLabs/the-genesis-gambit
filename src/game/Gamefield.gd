class_name Gamefield
extends Node

signal event(name : StringName, data : Dictionary)

@onready var cards_holder : Node2D = get_node("Cards")
@onready var client_ui : ClientUI = get_parent().get_node("CLIENT-UI")

var effect_resolver : EffectResolver = EffectResolver.new()
var players : Array[Player]

func _ready() -> void:
	effect_resolver.reflect_effect.connect(_handle_gamefield_effect)
	var new_player := Player.new(effect_resolver)
	new_player.name = "Player 1"
	players.append(new_player)
	self.add_child(new_player, true)

var _hovered_card : CardOnField = null
func get_hovered_card() -> CardOnField:
	return _hovered_card

func _process(_delta : float) -> void: 
	if Input.is_action_just_pressed("debug_advance_frame"):
		print("Advancing frame")
		effect_resolver.resolve_effects(GamefieldState.new(players))

func _handle_gamefield_effect(effect : Effect) -> void:
	if not effect is GamefieldEffect: return

	if effect is CreatureSpawnEffect:
		var spawn_effect : CreatureSpawnEffect = effect as CreatureSpawnEffect
		place_card(spawn_effect.creature, spawn_effect.position)
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

	var card_stats := IStatisticPossessor.id(card)
	cards_holder.add_child(card, true)
	card_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	card_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, true)

	var ap : AudioStreamPlayer2D = AudioDispatcher.dispatch_positional_audio(card, "res://ast/sound/cardplace.tres")
	ap.panning_strength = 0.25


