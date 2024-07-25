extends CardLogic

static var description : StringName = "Target creature attacks itself."

func process(_backend_state : MatchBackendState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		# AuthoritySourceProvider.authority_source.request_action(
		# 	CreatureAttackAction.setup(
		# 		target, target, IStatisticPossessor.id(target).get_statistic(Genesis.Statistic.STRENGTH)
		# 	)
		# )
		
# Gain Experience
# extends CardLogic

# static var description : StringName = "Whenever Target Creature attacks, it gains +1 power."

