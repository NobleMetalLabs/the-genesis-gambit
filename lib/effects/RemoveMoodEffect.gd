class_name RemoveMoodEffect
extends MoodEffect

var mood : Mood

func _init(_requester : Object, _target : IMoodPossessor, _mood : Mood) -> void:
	self.requester = _requester
	self.target = _target
	self.mood = _mood

func _to_string() -> String:
	return "RemoveMoodEffect(%s,%s)" % [self.target, self.mood]

func resolve(_effect_resolver : EffectResolver) -> void:
	target.remove_mood(mood)
