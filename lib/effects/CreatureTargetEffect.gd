class_name CreatureTargetEffect
extends CreatureEffect

var target : ITargetable

func _init(_creature : CardOnField, _target : ITargetable) -> void:
	self.creature = _creature
	self.target = _target

func _to_string() -> String:
	return "CreatureTargetEffect(%s,%s)" % [self.creature, self.target]

func resolve(effect_resolver : EffectResolver) -> void:
	self.creature.target = self.target
	var creature_stats := IStatisticPossessor.id(self.creature)
	var null_target : bool = self.target == null

	creature_stats.set_statistic(Genesis.Statistic.TARGET, self.target)
	if null_target:
		creature_stats.set_statistic(Genesis.Statistic.HAS_TARGET, false)
	else:
		creature_stats.set_statistic(Genesis.Statistic.HAS_TARGET, true)
		creature_stats.set_statistic(Genesis.Statistic.JUST_TARGETED, true)
		var just_targeted_expire_effect := SetStatisticEffect.new(creature_stats, Genesis.Statistic.JUST_TARGETED, false)
		just_targeted_expire_effect.requester = self.requester
		effect_resolver.request_effect(just_targeted_expire_effect)
	
		var target_stats := IStatisticPossessor.id(self.target)
		target_stats.set_statistic(Genesis.Statistic.WAS_JUST_TARGETED, true)
		var was_just_targeted_expire_effect := SetStatisticEffect.new(target_stats, Genesis.Statistic.WAS_JUST_TARGETED, false)
		was_just_targeted_expire_effect.requester = self.requester
		effect_resolver.request_effect(was_just_targeted_expire_effect)
	
	