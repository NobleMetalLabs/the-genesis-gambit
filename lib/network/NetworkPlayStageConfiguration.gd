class_name NetworkPlayStageConfiguration
extends Resource

var players : Array[NetworkPlayer]
var decks_by_player_uid : Dictionary #[int, Deck]

func _init(_players : Array[NetworkPlayer], _decks_by_player_uid : Dictionary) -> void:
	self.players = _players
	self.decks_by_player_uid = _decks_by_player_uid