class_name CreatureTargetEffect
extends CreatureEffect

var target : ITargetable

func _init(_requester : Object, _creature : ICardInstance, _target : ITargetable) -> void:
	self.requester = _requester
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
		effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, creature_stats, Genesis.Statistic.JUST_TARGETED, false
		))
	
		var target_stats := IStatisticPossessor.id(self.target)
		target_stats.set_statistic(Genesis.Statistic.WAS_JUST_TARGETED, true)
		effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, target_stats, Genesis.Statistic.WAS_JUST_TARGETED, false
		))
	
	