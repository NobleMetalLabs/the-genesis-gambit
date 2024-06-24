class_name StatisticMood
extends Mood

var statistic : Genesis.Statistic
var effect : Mood.MoodEffect
var amount : int

func _init(_source : ICardInstance, _statistic : Genesis.Statistic, _effect : Mood.MoodEffect, _amount : int = 1) -> void:
	self.statistic = _statistic
	self.effect = _effect
	self.source = _source
	self.amount = _amount

func _to_string() -> String:
	return "StatisticMood(\n<%s>, \n%s, %s, %d\n)" % [self.source, Genesis.Statistic.keys()[self.statistic], Mood.MoodEffect.keys()[self.effect], self.amount]