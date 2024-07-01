class_name Gamefield
extends Node

signal game_completed()
signal event(name : StringName, data : Dictionary)

var cards_holder : Node2D

var client_ui : ClientUI
var effect_resolver : EffectResolver = EffectResolver.new()
var players : Array[Player]

func setup(config : NetworkPlayStageConfiguration) -> void:
	cards_holder = get_node("Cards")

	for nplayer : NetworkPlayer in config.players:
		var player_deck : Deck = config.decks_by_player_uid[nplayer.uid]
		var player := Player.new(nplayer, player_deck)
		players.append(player)
		player.name = nplayer.player_name
		player.leader = ICardInstance.new(player_deck.leader, player)
		var leader : CardOnField = CardOnField.new([player.leader])
		place_card(leader, Vector2(960, 540 * 1.5))
		self.add_child(player, true)

var _hovered_card : CardOnField = null
func get_hovered_card() -> CardOnField:
	return _hovered_card

func get_gamefield_state() -> GamefieldState:
	return GamefieldState.new(players)

func _process(_delta : float) -> void: 
	if Input.is_action_just_pressed("debug_advance_frame"):
		print("Advancing frame")
		effect_resolver.resolve_effects(get_gamefield_state())

	for player in players:
		var leader_stats := IStatisticPossessor.id(player.leader)
		if leader_stats.get_statistic(Genesis.Statistic.JUST_DIED):
			self.game_completed.emit()

# TODO: make panning strength a user setting
func place_card(card : CardOnField, position : Vector2) -> void:
	card.position = position

	self.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		card.logic.process_event(event_name, data)
	)
	card.card_frontend.mouse_entered.connect(
		func() -> void:
			_hovered_card = card
	)
	card.card_frontend.mouse_exited.connect(
		func() -> void:
			_hovered_card = null
	)

	cards_holder.add_child(card, true)
	
	var ap : AudioStreamPlayer2D = AudioDispatcher.dispatch_positional_audio(card, "res://ast/sound/cardplace.tres")
	ap.panning_strength = 0.25
