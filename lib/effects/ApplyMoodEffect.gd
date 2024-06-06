class_name ApplyMoodEffect
extends MoodEffect

var mood : Mood

func _init(_target : IMoodPossessor, _mood : Mood) -> void:
	self.target = _target
	self.mood = _mood

func _to_string() -> String:
	return "ApplyMoodEffect(%s,%s)" % [self.target, self.mood]

func resolve(_er : EffectResolver) -> void:
	target.apply_mood(mood)
