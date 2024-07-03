class_name GamefieldState
extends Resource

var state_players : Array[Player] = [] #modified player to remove all invalid instances #TODO: this probably sucks
var cards : Array[ICardInstance] = []
var _players_to_state_players : Dictionary = {} # [Player, Player]

func _init(_players : Array[Player]) -> void:
	for p : Player in _players:
		var state_player : Player = Player.new(p.network_player, Deck.EMPTY)
		var player_cards : Array[ICardInstance] = []
		for card : CardInHand in p.cards_in_hand:
			if is_instance_valid(card):
				player_cards.append(ICardInstance.id(card))
		for card :CardOnField in p.cards_on_field:
			if is_instance_valid(card):
				player_cards.append(ICardInstance.id(card))
		for card : CardInDeck in p.cards_in_deck:
			if is_instance_valid(card):
				player_cards.append(ICardInstance.id(card))
		cards.append_array(player_cards)
		state_players.append(state_player)
		_players_to_state_players[p] = state_player

func get_player_from_instance(instance : ICardInstance) -> Player:
	return _players_to_state_players[instance.player]

