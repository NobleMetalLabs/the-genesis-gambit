class_name SetStatisticEffect
extends StatisticEffect

var statistic : Genesis.Statistic
var value : Variant

func _init(_target : IStatisticPossessor, _statistic : Genesis.Statistic, _value : Variant) -> void:
	target = _target
	statistic = _statistic
	value = _value

func _to_string() -> String:
	return "SetStatisticEffect(%s, %s, %s)" % [target, Genesis.Statistic.keys()[statistic], value]

func resolve(_er : EffectResolver) -> void:
	target.set_statistic(statistic, value)