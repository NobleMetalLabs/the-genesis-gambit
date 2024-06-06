class_name RemoveMoodEffect
extends MoodEffect

var mood : Mood

func _init(_target : IMoodPossessor, _mood : Mood) -> void:
	self.target = _target
	self.mood = _mood

func _to_string() -> String:
	return "RemoveMoodEffect(%s,%s)" % [self.target, self.mood]

func resolve(_er : EffectResolver) -> void:
	target.remove_mood(mood)
