class_name NetworkPlayStageConfiguration
extends Serializeable

var players : Array[NetworkPlayer]
var decks_by_player_uid : Dictionary #[int, Deck]

static func setup(_players : Array[NetworkPlayer], _decks_by_player_uid : Dictionary) -> NetworkPlayStageConfiguration:
	var npsc := NetworkPlayStageConfiguration.new()
	npsc.players = _players
	npsc.decks_by_player_uid = _decks_by_player_uid
	return npsc