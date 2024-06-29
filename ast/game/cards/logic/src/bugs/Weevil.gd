extends CardLogic

static var description : StringName = "When Weevil enters play from your hand, create a copy of it."

var protected_creatures : Array[ICardInstance] = []

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_PLAYED): 
		# TODO: Can't check if it was played from hand w/o scitzo watching all effects and smellin mad state.
		# Theoretically, _effect_resolver should be able to be queried for all effects that have been relevant to a card, including resolved ones.
		# This would also reduce the amount of effect_list looping.
		_effect_resolver.request_effect(
			HandAddCardEffect.new(
				instance_owner,
				_gamefield_state.get_player_from_instance(instance_owner),
				false,
				true,
				instance_owner.metadata.id
			)
		)