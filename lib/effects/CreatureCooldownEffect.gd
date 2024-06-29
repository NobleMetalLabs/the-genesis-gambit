class_name CreatureCooldownEffect
extends CreatureEffect

var type : Genesis.CooldownType
var stage : Genesis.CooldownStage
var frames : int = 0

func _init(_requester : Object, _creature : ICardInstance, _type : Genesis.CooldownType, _stage : Genesis.CooldownStage, _frames : int) -> void:
	self.requester = _requester
	self.creature = _creature
	self.type = _type
	self.stage = _stage
	self.frames = _frames

func _to_string() -> String:
	return "CreatureCooldownEffect(%s,%s,%s,%s)" % [self.creature, self.type, self.stage, self.frames]

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_REMAINING, self.frames)

	#TODO: Handle CooldownType, interplay with CreatureActivateEffect

	if self.stage != Genesis.CooldownStage.FINISH:
		if self.stage == Genesis.CooldownStage.START:
			creature_stats.set_statistic(Genesis.Statistic.JUST_STARTED_COOLDOWN, true)
			creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, true)
			_effect_resolver.request_effect(SetStatisticEffect.new(
				self.requester, creature_stats, Genesis.Statistic.JUST_STARTED_COOLDOWN, false
			))
		else:
			if self.frames == 0:
				_effect_resolver.request_effect(CreatureCooldownEffect.new(
					self.requester,
					self.creature,
					self.type,
					Genesis.CooldownStage.FINISH,
					0
				))
				return
		_effect_resolver.request_effect(CreatureCooldownEffect.new(
			self.requester,
			self.creature,
			self.type,
			Genesis.CooldownStage.IN_PROGRESS,
			self.frames - 1
		))
		
	else:

		creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, false)
		creature_stats.set_statistic(Genesis.Statistic.JUST_FINISHED_COOLDOWN, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, creature_stats, Genesis.Statistic.JUST_FINISHED_COOLDOWN, false
		))


