class_name Player
extends Node

var cards_in_deck : Array[CardInDeck] = []
var cards_in_hand : Array[CardInHand] = []
var cards_on_field : Array[CardOnField] = []
var leader : ICardInstance

static var scn : PackedScene = preload("res://scn/ui/Player.tscn")
static func setup(deck : Deck) -> Player:
	var player := scn.instantiate()

	for card : CardMetadata in deck.get_cards():
		var card_instance := ICardInstance.new(
			card,
			player
		)
		var stats := IStatisticPossessor.new()
		stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
		if card_instance.metadata.rarity == Genesis.CardRarity.LEADER:
			player.leader = card_instance
		else:
			player.cards_in_deck.append(CardInDeck.new([card_instance, stats]))
	return player

func _ready() -> void:
	seed(Router.backend.player_to_peer_id[self])
	cards_in_deck.shuffle()

func _to_string() -> String:
	return "Player<%s>" % [self.name]
