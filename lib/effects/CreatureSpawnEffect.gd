class_name CreatureSpawnEffect
extends CreatureEffect 

var keep_stats : bool
var keep_moods : bool

func _init(_requester : Object, _card : ICardInstance,  _keep_stats : bool = true, _keep_moods : bool = true) -> void:
	self.requester = _requester
	self.creature = _card
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods

func _to_string() -> String:
	return "CreatureSpawnEffect(%s,%s,%s)" % [self.creature, self.keep_stats, self.keep_moods]

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(creature)

	creature_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, true)
	self.creature.player.cards_on_field.append(creature)
	#TODO: keep_stats and keep_moods do anything

	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.WAS_JUST_PLAYED, false
	))
