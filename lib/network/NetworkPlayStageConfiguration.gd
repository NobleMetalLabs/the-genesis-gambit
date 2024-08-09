class_name NetworkPlayStageConfiguration
extends Serializeable

var players : Array[NetworkPlayer]
var decks_by_player_uid : Dictionary #[int, Deck]
var rng_seed : int

func _to_string() -> String:
	return "NetworkPlayStageConfiguration(%s, %s)" % [players, decks_by_player_uid]

static func setup(_players : Array[NetworkPlayer], _decks_by_player_uid : Dictionary, _rng_seed : int = hash(Time.get_unix_time_from_system())) -> NetworkPlayStageConfiguration:
	var npsc := NetworkPlayStageConfiguration.new()
	npsc.players = _players
	npsc.decks_by_player_uid = _decks_by_player_uid
	npsc.rng_seed = _rng_seed
	return npsc
	