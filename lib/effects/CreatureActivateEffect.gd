class_name CreatureActivateEffect
extends CreatureEffect

func _init(_requester : Object, _creature : ICardInstance) -> void:
	self.requester = _requester
	self.creature = _creature

func _to_string() -> String:
	return "CreatureActivateEffect(%s)" % self.creature

func resolve(effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED, true)
	effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.WAS_JUST_ACTIVATED, false
	))
	var flash_tween : Tween = Router.get_tree().create_tween()
	flash_tween.tween_property(self.creature, "modulate", Color(0, 1, 0, 1), 0)
	flash_tween.tween_property(self.creature, "modulate", Color(1, 1, 1, 1), 0.5)