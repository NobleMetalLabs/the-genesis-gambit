class_name BoredomMood
extends Mood

func _init(_source : ICardInstance) -> void:
	self.source = _source

func _to_string() -> String:
	return "BoredomMood(%s)" % self.source
