class_name NetworkMatchConfiguration
extends Resource

var players : Array[NetworkPlayer]
var ruleset : MatchRuleset

func _init(_players : Array[NetworkPlayer], _ruleset : MatchRuleset) -> void:
	self.players = _players
	self.ruleset = _ruleset

static var dummy_config : NetworkMatchConfiguration = NetworkMatchConfiguration.new([NetworkPlayer.setup(0, "Player 1")], MatchRuleset.new())