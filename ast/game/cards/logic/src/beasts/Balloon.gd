extends CardLogic

static var description : StringName = "The next time targeted creature is attacked, it makes an attack against the attacker at half strength."

var watching_creatures : Array[ICardInstance]

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		watching_creatures.append(target)

	for effect in _effect_resolver.effect_list:
		if not effect is CreatureAttackEffect: continue
		effect = effect as CreatureAttackEffect
		if not effect.creature in watching_creatures: continue
		_effect_resolver.request_effect(
			CreatureAttackEffect.new(
				instance_owner,
				instance_owner,
				effect.creature,
				my_stats.get_statistic(Genesis.Statistic.STRENGTH) / 2
			)
		)
		watching_creatures.erase(effect.creature)
