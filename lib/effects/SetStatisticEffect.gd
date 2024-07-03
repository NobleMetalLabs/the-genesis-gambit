class_name SetStatisticEffect
extends StatisticEffect

var statistic : Genesis.Statistic
var value : Variant

func _init(_requester : Object, _target : IStatisticPossessor, _statistic : Genesis.Statistic, _value : Variant) -> void:
	self.requester = _requester
	self.target = _target
	self.statistic = _statistic
	self.value = _value

func _to_string() -> String:
	return "SetStatisticEffect(%s, %s, %s)" % [target, Genesis.Statistic.keys()[statistic], value]

func resolve(_effect_resolver : EffectResolver) -> void:
	target.set_statistic(statistic, value)