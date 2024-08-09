class_name SummoningMood
extends Mood

func _init(_source : ICardInstance) -> void:
	self.source = _source

func _to_string() -> String:
	return "SummoningMood(%s)" % self.source
