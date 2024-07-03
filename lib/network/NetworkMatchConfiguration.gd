class_name NetworkMatchConfiguration
extends Resource

var players : Array[NetworkPlayer]
var ruleset : MatchRuleset

func _init(players : Array[NetworkPlayer], ruleset : MatchRuleset) -> void:
	self.players = players
	self.ruleset = ruleset

static var dummy_config : NetworkMatchConfiguration = NetworkMatchConfiguration.new([NetworkPlayer.new(0, "Player 1")], MatchRuleset.new())