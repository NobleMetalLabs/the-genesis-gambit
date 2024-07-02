class_name Player
extends Node

var deck : Deck 
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []
var leader : ICardInstance

func _init() -> void:
	deck = Deck.new()
	# for i in range(0, 15):
	# 	var card_instance := ICardInstance.new(
	# 		CardDB.cards.pick_random(),
	# 		self
	# 	)
	# 	var stats := IStatisticPossessor.new()
	# 	stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
	# 	deck.add_card(CardInDeck.new([card_instance, stats]))
	deck.add_card(CardInDeck.new([ICardInstance.new(CardDB.get_card_by_id(10), self)]))
	deck.add_card(CardInDeck.new([ICardInstance.new(CardDB.get_card_by_id(9), self)]))
	deck.shuffle()

func _to_string() -> String:
	return "Player<%s>" % [self.name]
