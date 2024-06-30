extends CardLogic

static var description : StringName = "When you have zero cards in hand, sacrifice Kelly and draw three cards."

var previous_target : ITargetable = null

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD): return
	if instance_owner.owner.hand.size() > 0: return
	effect_resolver.request_effect(
		CreatureLeavePlayEffect.new(
			instance_owner,
			instance_owner,
			instance_owner,
			Genesis.LeavePlayReason.SACRIFICED
		)
	)
	for i in range(3):
		effect_resolver.request_effect(
			HandAddCardEffect.new(
				instance_owner,
				instance_owner.player
			)
		)