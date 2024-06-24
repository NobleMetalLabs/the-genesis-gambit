extends CardLogic

static var description : StringName = "The Rarity of the top card of your deck is visible to you."

func process(_gs : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var player_stats := IStatisticPossessor.id(instance_owner.player)
	var is_on_field : bool = my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	var top_card_visible : bool = player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_RARITY_ONLY)
	if is_on_field != top_card_visible:
		player_stats.set_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE, is_on_field)
		player_stats.set_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_RARITY_ONLY, is_on_field)
		