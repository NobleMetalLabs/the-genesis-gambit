class_name MatchBackendState
extends Resource

var state_players : Array[Player] = [] #modified player to remove all invalid instances #TODO: this probably sucks
var cards : Array[ICardInstance] = []
var _players_to_state_players : Dictionary = {} # [Player, Player]

func _init(_players : Array[Player]) -> void:
	for p : Player in _players:
		var state_player : Player = Player.setup(Deck.EMPTY)
		cards = p.cards_in_hand + p.cards_on_field + p.cards_in_deck
		state_players.append(state_player)
		_players_to_state_players[p] = state_player

func get_player_from_instance(instance : ICardInstance) -> Player:
	return _players_to_state_players[instance.player]

