extends CardLogic

static var description : StringName = "When Mother Spider dies, create three Spiders."

var protected_creatures : Array[ICardInstance] = []

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.JUST_DIED):
		for i in range(3):
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					_gamefield_state.get_player_from_instance(instance_owner),
					false,
					true,
					CardDB.get_id_by_name("Spider")
				)
			)