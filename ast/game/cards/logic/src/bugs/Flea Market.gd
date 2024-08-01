extends CardLogic

static var description : StringName = "Activate: If Flea Market has no charges, a charge from Targeted creature is transfered to Flea Market. Otherwise, a charge from Flea Market is transfered to Targeted creature."

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
			var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
			var target_stats := IStatisticPossessor.id(target)
			if my_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
				my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
				target_stats.modify_statistic(Genesis.Statistic.CHARGES, 1)
			else:
				if target_stats.get_statistic(Genesis.Statistic.CHARGES) >= 1:
					target_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
					my_stats.modify_statistic(Genesis.Statistic.CHARGES, 1)