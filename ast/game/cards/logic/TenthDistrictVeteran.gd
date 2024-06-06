extends CardLogic

static var description : StringName = "Whenever this creature attacks, gain a charge. Whenever this is activated, the creature its targeting completes its activation cooldown."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
		my_stats.modify_statistic(Genesis.Statistic.CHARGES, 1)

	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
		if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
			var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
			AuthoritySourceProvider.authority_source.submit_action(
				CreatureCooldownAction.new(
					target.get_owner(),
					Genesis.CooldownType.ACTIVATE,
					Genesis.CooldownStage.FINISH
				)
			) 