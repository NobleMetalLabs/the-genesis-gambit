class_name StatisticMood
extends Mood

var statistic : StringName
var effect : MoodEffect

func _init(_statistic : StringName, _effect : MoodEffect) -> void:
	self.statistic = _statistic
	self.effect = _effect