extends CardLogic

static var description : StringName = "Whenever the Fungus Garden gains a charge, heal 1 health."

var last_seen_num_charges : int = 0

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD) == false: return
	var leader : ICardInstance = instance_owner.player.leader
	var leader_stats := IStatisticPossessor.id(leader)
	var num_charges : int = leader_stats.get_statistic(Genesis.Statistic.CHARGES)
	if num_charges > last_seen_num_charges:
		_effect_resolver.request_effect(
			ModifyStatisticEffect.new(
				instance_owner,
				IStatisticPossessor.id(instance_owner),
				Genesis.Statistic.HEALTH,
				1
			)
		)
	last_seen_num_charges = num_charges
