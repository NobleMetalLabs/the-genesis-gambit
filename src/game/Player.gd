class_name Player
extends Node

var cards_in_deck : Array[ICardInstance] = []
var cards_in_hand : Array[ICardInstance] = []
var cards_on_field : Array[ICardInstance] = []
var leader : ICardInstance

static var scn : PackedScene = preload("res://scn/game/Player.tscn")
static func setup(deck : Deck) -> Player:
	var player := scn.instantiate()

	for card : CardMetadata in deck.get_cards():
		var card_instance := ICardInstance.new(
			card,
			player
		)
		if card_instance.metadata.rarity == Genesis.CardRarity.LEADER:
			player.leader = card_instance
			player.cards_on_field.append(card_instance)
		else:
			player.cards_in_deck.append(card_instance)
	return player

func _ready() -> void:
	seed(Router.backend.player_to_peer_id[self])
	cards_in_deck.shuffle()

func _to_string() -> String:
	return "Player<%s>" % [self.name]
