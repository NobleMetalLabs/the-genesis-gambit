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

	#TODO: Cards only WAS_JUST_PLAYED if coming from hand; seperate WAS_JUST_SPAWNED to replace here
	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.WAS_JUST_PLAYED, false
	))

	var creature_moods := IMoodPossessor.id(creature) 
	var ssickness_mood := SummoningMood.new(creature)

	creature_stats.set_statistic(Genesis.Statistic.CAN_ATTACK, false)
	creature_moods.apply_mood(ssickness_mood)
	
	_effect_resolver.request_effect(
		CooldownEffect.new(
			self.requester,
			creature_stats,
			Genesis.CooldownType.SSICKNESS,
			(10 / max(1, self.creature.metadata.speed)) * 5,
			(func remove_summoning_sickness() -> void:
				creature_stats.set_statistic(Genesis.Statistic.CAN_ATTACK, true)
				creature_moods.remove_mood(ssickness_mood))
		)
	)
	
	var energy_to_add : int = IStatisticPossessor.id(creature).get_statistic(Genesis.Statistic.ENERGY)
	IStatisticPossessor.id(creature.player).modify_statistic(Genesis.Statistic.ENERGY, energy_to_add)
