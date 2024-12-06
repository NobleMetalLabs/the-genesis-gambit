extends CardLogic

static var description : StringName = "Targeted creature is dealt 2 damage."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD) == false: return
	if my_stats.get_cooldown_of_type(Genesis.CooldownType.SSICKNESS) != null: return
	
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		_effect_resolver.request_effect(
			CreatureAttackEffect.new(
				instance_owner,
				instance_owner,
				target,
				2
			)
		)
		
		_effect_resolver.request_effect(
			CreatureLeavePlayEffect.new(
				instance_owner,
				instance_owner,
				instance_owner,
				Genesis.LeavePlayReason.SPENT
			)
		)
