extends CardLogic

static var description : StringName = "Gains 1 Happy for every creature currently tending the Fungus Garden."

var last_seen_num_garden_tenders : int = 0
var self_moods : Array[StatisticMood] = []

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var curr_num_tenders : int = 0
	for card : ICardInstance in instance_owner.player.cards_on_field:
		var card_target : ICardInstance = IStatisticPossessor.id(card).get_statistic(Genesis.Statistic.TARGET)
		var target_card : ICardInstance = ICardInstance.id(card_target)
		if not target_card: continue
		if not target_card.player == instance_owner.player: continue
		if target_card.metadata.name == "Fungus Garden": #Is this slow? Bad, even?
			curr_num_tenders += 1

	var my_moods := IMoodPossessor.id(instance_owner)
	if curr_num_tenders != last_seen_num_garden_tenders:
		if curr_num_tenders > self_moods.size():
			for i in range(self_moods.size(), curr_num_tenders):
				var mood := StatisticMood.HAPPY(instance_owner)
				self_moods.push_back(mood)
				_effect_resolver.request_effect(
					ApplyMoodEffect.new(
						instance_owner,
						my_moods,
						mood
					)
				)
		else:
			for i in range(curr_num_tenders, self_moods.size()):
				var mood : Mood = self_moods.pop_back()
				_effect_resolver.request_effect(
					RemoveMoodEffect.new(
						instance_owner,
						my_moods,
						mood
					)
				)
		last_seen_num_garden_tenders = curr_num_tenders
