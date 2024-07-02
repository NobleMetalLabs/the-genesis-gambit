extends CardLogic

static var description : StringName = "Activate: Transform between Quetza and Xolotl. During Quetza, whenever Quetzaxolotl makes an attack, lose a max energy and draw a card. During Xolotl, marked cards act as though they are unmarked."

enum State {
	QUETZA,
	XOLOTL
}

var state : State = State.QUETZA

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_staticic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		for card in _gamefield_state.cards:
			if card.player != instance_owner.player: continue
			IStatisticPossessor.id(card).set_statistic(Genesis.Statistic.ACTS_AS_UNMARKED, state == State.XOLOTL)
		state = ((not ((state as int) as bool) as int) as State)

	if state == State.QUETZA:
		for effect in _effect_resolver.effect_list:
			if not effect is CreatureAttackEffect: continue
			effect = effect as CreatureAttackEffect
			if effect.creature != instance_owner: continue
			my_stats.modify_statistic(Genesis.Statistic.MAX_ENERGY, -1)
			_effect_resolver.request_effect(
				HandAddCardEffect.new(
					instance_owner,
					instance_owner.player
				)
			)
			return
			

