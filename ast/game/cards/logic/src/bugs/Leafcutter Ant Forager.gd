extends CardLogic

static var description : StringName = "When Leafcutter Ant Forager kills an enemy, a stack of fungus is added to the Fungus Garden."

var fungus_garden : ICardInstance = null

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	if not fungus_garden:
		for cof : CardOnField in _gamefield_state.get_player_from_instance(instance_owner).cards_on_field:
			var card := ICardInstance.id(cof)
			if not card: continue
			if card.card_name == "Fungus Garden":
				fungus_garden = card
				break
	
	var my_stats := IStatisticPossessor.id(instance_owner)
	var most_recent_attacked := ICardInstance.id(my_stats.get_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED))
	if not most_recent_attacked: return
	var mra_stats := IStatisticPossessor.id(most_recent_attacked)

	if mra_stats.get_statistic(Genesis.Statistic.JUST_DIED):
		IStatisticPossessor.id(fungus_garden).modify_statistic(Genesis.Statistic.CHARGES, 1)