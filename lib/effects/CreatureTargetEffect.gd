class_name CreatureTargetEffect
extends CreatureEffect

var target : ICardInstance

func _init(_requester : Object, _creature : ICardInstance, _target : ICardInstance) -> void:
	self.requester = _requester
	self.creature = _creature
	self.target = _target

func _to_string() -> String:
	return "CreatureTargetEffect(%s,%s)" % [self.creature, self.target]

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	var null_target : bool = self.target == null

	if null_target:
		creature_stats.set_statistic(Genesis.Statistic.HAS_TARGET, false)
	else:
		var target_stats := IStatisticPossessor.id(self.target)

		var target_should_fail : bool = false
		target_should_fail = \
			(not target_stats.get_statistic(Genesis.Statistic.CAN_BE_TARGETED)) or \
			(target == creature and not target_stats.get_statistic(Genesis.Statistic.CAN_TARGET_SELF)) or \
			(target_stats.get_statistic(Genesis.Statistic.CAN_BE_TARGETED_FRIENDLIES_ONLY) and not target.player == creature.player) or \
			(target_stats.get_statistic(Genesis.Statistic.CAN_BE_TARGETED_OPPONENTS_ONLY) and not target.player != creature.player)

		if target_should_fail:
			self.resolve_status = ResolveStatus.FAILED
			return

		creature_stats.set_statistic(Genesis.Statistic.HAS_TARGET, true)
		creature_stats.set_statistic(Genesis.Statistic.JUST_TARGETED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, creature_stats, Genesis.Statistic.JUST_TARGETED, false
		))
	
		
		target_stats.set_statistic(Genesis.Statistic.WAS_JUST_TARGETED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, target_stats, Genesis.Statistic.WAS_JUST_TARGETED, false
		))
	creature_stats.set_statistic(Genesis.Statistic.TARGET, self.target)
	
	
