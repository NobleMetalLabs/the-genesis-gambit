class_name Player
extends Node

var cards_in_deck : Array[CardInDeck] = []
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []
var leader : ICardInstance

var network_player : NetworkPlayer

func _init(_network_player : NetworkPlayer, deck : Deck) -> void:
	self.network_player = _network_player
	for card : CardMetadata in deck.get_cards():
		var card_instance := ICardInstance.new(
			card,
			self
		)
		var stats := IStatisticPossessor.new()
		stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
		cards_in_deck.append(CardInDeck.new([card_instance, stats]))
	cards_in_deck.shuffle()

func _to_string() -> String:
	return "Player<%s>" % [self.name]
