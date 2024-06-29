extends CardLogic

static var description : StringName = "Gains Strength for every card in your hand."

var saved_hand_card_count : int = -1

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)

	var num_handcards : int = _gamefield_state.get_player_from_instance(instance_owner).cards_in_hand.size()
	if saved_hand_card_count == -1:
		saved_hand_card_count = num_handcards

	if num_handcards != saved_hand_card_count:
		var handcard_num_delta : int = num_handcards - saved_hand_card_count
		_effect_resolver.request_effect(
			ModifyStatisticEffect.new(
				instance_owner,
				my_stats,
				Genesis.Statistic.STRENGTH,
				handcard_num_delta
			)
		)
		saved_hand_card_count = num_handcards