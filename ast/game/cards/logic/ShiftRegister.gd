extends CardLogic

static var description : StringName = "When held in the players hand, whenever you would draw a card, draw two instead."

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	if not is_on_field: return
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED):
		my_stats.set_statistic(Genesis.Statistic.NUM_ACTIVATIONS, 3)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.NUM_ACTIVATIONS) > 0:
			my_stats.modify_statistic(Genesis.Statistic.NUM_ACTIVATIONS, -1)
			print("Activated!")
		else:
			print("Not enough activations")
