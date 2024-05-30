extends CardLogic

static var description : StringName = "Yep"

func process() -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var my_card : CardOnField = instance_owner.get_object()

	if my_stats.get_statistic("just_placed"):
		my_stats.set_statistic("just_placed", false)
		var board : Node2D = my_card.get_parent()
		for card in board.get_children():
			if card == my_card: continue
			IMoodPossessor.id(card).apply_mood(StatisticMood.new(
				"health", Mood.MoodEffect.EXPOSITIVE
			))
