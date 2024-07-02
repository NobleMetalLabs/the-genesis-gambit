extends CardLogic

static var description : StringName = "Gains Strength for every card in your hand."

var saved_hand_card_count : int = -1

func process(_gs : GamefieldState, effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)

	var num_handcards : int = instance_owner.player.cards_in_hand.size()
	if saved_hand_card_count == -1:
		saved_hand_card_count = num_handcards

	if num_handcards != saved_hand_card_count:
		var handcard_num_delta : int = num_handcards - saved_hand_card_count
		effect_resolver.request_effect(
			ModifyStatisticEffect.new(
				instance_owner,
				my_stats,
				Genesis.Statistic.STRENGTH,
				handcard_num_delta
			)
		)
		saved_hand_card_count = num_handcards