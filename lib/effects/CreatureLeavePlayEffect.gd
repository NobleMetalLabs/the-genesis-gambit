class_name CreatureLeavePlayEffect
extends CreatureEffect

var source : ICardInstance
var reason : Genesis.LeavePlayReason

func _init(_requester : Object, _creature : ICardInstance, _source : ICardInstance, _reason : Genesis.LeavePlayReason = Genesis.LeavePlayReason.DIED) -> void:
	self.requester = _requester
	self.creature = _creature
	self.source = _source
	self.reason = _reason

#TODO: give this effect a destination enum that handles creates the *AddCardEffect instead of those effects being made and forced to do cleanup

func _to_string() -> String:
	return "CreatureLeavePlayEffect(%s,%s,%s)" % [self.creature, self.source, self.reason]

func resolve(_effect_resolver : EffectResolver) -> void:
	var player_owner : Player = ICardInstance.id(self.creature).player
	_effect_resolver.request_effect(DeckAddCardEffect.new(
		self, player_owner, ICardInstance.id(self.creature)
	))

	var creature_stats := IStatisticPossessor.id(creature)
	var source_stats := IStatisticPossessor.id(source)
	
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_KILLED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.WAS_JUST_KILLED, false
	))

	source_stats.set_statistic(Genesis.Statistic.JUST_KILLED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, source_stats, Genesis.Statistic.JUST_KILLED, false
	))
	
	creature_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, false)
	
	# Lmk if there's a better way to do get all cards on field, I didn't think about it too hard
	for player : Player in Router.backend.players:
		for card_on_field : ICardInstance in player.cards_on_field:
			if creature == IStatisticPossessor.id(card_on_field).get_statistic(Genesis.Statistic.TARGET):
				IStatisticPossessor.id(card_on_field).set_statistic(Genesis.Statistic.TARGET, null)
	
	var energy_to_remove : int = creature_stats.get_statistic(Genesis.Statistic.ENERGY)
	IStatisticPossessor.id(creature.player).modify_statistic(Genesis.Statistic.ENERGY, -energy_to_remove)
	
	creature.player.cards_on_field.erase(creature)
	
