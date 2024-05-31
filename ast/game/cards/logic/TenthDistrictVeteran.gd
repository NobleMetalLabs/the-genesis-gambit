extends CardLogic

static var description : StringName = "Whenever this creature attacks, gain a charge. Whenever this is activated, the creature its targeting completes its activation cooldown."

func process(_effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic("just_attacked"):
		my_stats.modify_statistic("activation_charges", 1)

	if my_stats.get_staticic("just_activated"):
		my_stats.modify_statistic("activation_charges", -1)
		if my_stats.get_statistic("has_target"):
			var target : ITargetable = my_stats.get_statistic("target")
			AuthoritySourceProvider.authority_source.submit_action(
				CreatureCooldownAction.new(
					target.get_owner(),
					CreatureCooldownAction.CooldownType.ACTIVATE,
					CreatureCooldownAction.CooldownStage.FINISH
				)
			) 