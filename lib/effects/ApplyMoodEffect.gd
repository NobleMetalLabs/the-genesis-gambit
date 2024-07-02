class_name ApplyMoodEffect
extends MoodEffect

var mood : Mood

func _init(_requester : Object, _target : IMoodPossessor, _mood : Mood) -> void:
	self.requester = _requester
	self.target = _target
	self.mood = _mood

func _to_string() -> String:
	return "ApplyMoodEffect(%s,%s)" % [self.target, self.mood]

func resolve(_er : EffectResolver) -> void:
	target.apply_mood(mood)
