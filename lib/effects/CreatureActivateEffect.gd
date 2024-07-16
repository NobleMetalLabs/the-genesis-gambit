class_name CreatureActivateEffect
extends CreatureEffect

func _init(_requester : Object, _creature : ICardInstance) -> void:
	self.requester = _requester
	self.creature = _creature

func _to_string() -> String:
	return "CreatureActivateEffect(%s)" % self.creature

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.WAS_JUST_ACTIVATED, false
	))