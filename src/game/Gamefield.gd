class_name Gamefield
extends Node

signal game_completed()
signal event(name : StringName, data : Dictionary)

var cards_holder : Node2D

var client_ui : ClientUI
var effect_resolver : EffectResolver = EffectResolver.new()
var players : Array[Player]

var network_player_to_player : Dictionary = {} # [NetworkPlayer, Player]

func setup(config : NetworkPlayStageConfiguration) -> void:
	cards_holder = get_node("Cards")

	for nplayer : NetworkPlayer in config.players:
		var player_deck : Deck = config.decks_by_player_uid[nplayer.peer_id]
		var player := Player.new(nplayer, player_deck)
		network_player_to_player[nplayer] = player
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
	for player in players:
		var leader_stats := IStatisticPossessor.id(player.leader)
		if leader_stats.get_statistic(Genesis.Statistic.JUST_DIED):
			self.game_completed.emit()
			
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
