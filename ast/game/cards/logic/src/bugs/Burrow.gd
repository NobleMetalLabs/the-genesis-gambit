extends CardLogic

static var description : StringName = "Targeted attacker burrows. While burrowed, it cannot be attacked, but may only make attacks against Supports. It remains burrowed until it has made 3 attacks."

var burrower : ICardInstance = null
var burrower_attacks : int = 0

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if not burrower:
		if my_stats.get_statistic(Genesis.Statistic.JUST_TARGETED):
			var target : ITargetable = my_stats.get_statistic(Genesis.Statistic.TARGET)
			burrower = ICardInstance.id(target)
			var burrower_stats := IStatisticPossessor.id(burrower)
			_effect_resolver.request_effect(
				SetStatisticEffect.new(
					instance_owner,
					burrower_stats,
					Genesis.Statistic.CAN_BE_ATTACKED,
					false
				)
			)
			_effect_resolver.request_effect(
				SetStatisticEffect.new(
					instance_owner,
					burrower_stats,
					Genesis.Statistic.CAN_TARGET_ATTACKERS,
					false
				)
			)
			_effect_resolver.request_effect(
				SetStatisticEffect.new(
					instance_owner,
					burrower_stats,
					Genesis.Statistic.CAN_TARGET_INSTANTS,
					false
				)
			)
	else:
		var burrower_stats := IStatisticPossessor.id(burrower)
		if burrower_stats.get_statistic(Genesis.Statistic.JUST_ATTACKED):
			burrower_attacks += 1
			if burrower_attacks >= 3:
				_effect_resolver.request_effect(
					SetStatisticEffect.new(
						instance_owner,
						burrower_stats,
						Genesis.Statistic.CAN_BE_ATTACKED,
						true
					)
				)
				_effect_resolver.request_effect(
					SetStatisticEffect.new(
						instance_owner,
						burrower_stats,
						Genesis.Statistic.CAN_TARGET_ATTACKERS,
						true
					)
				)
				_effect_resolver.request_effect(
					SetStatisticEffect.new(
						instance_owner,
						burrower_stats,
						Genesis.Statistic.CAN_TARGET_INSTANTS,
						true
					)
				)
