extends CardLogic

static var description : StringName = "Whenever you play an instant, create gains +1 damage."

var saved_instant_play_count : int = -1

func process() -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	var my_player : Player = instance_owner.player
	var my_player_stats := IStatisticPossessor.id(my_player)

	var num_instants : int = my_player_stats.get_statistic("num_instants_played")
	if saved_instant_play_count == -1:
		saved_instant_play_count = num_instants

	if num_instants > saved_instant_play_count:
		saved_instant_play_count = num_instants
		var num_new_instants : int = num_instants - saved_instant_play_count
		my_stats.modify_statistic("damage", num_new_instants)

