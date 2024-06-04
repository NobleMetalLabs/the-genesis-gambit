class_name CreatureCooldownEffect
extends CreatureEffect

var type : Genesis.CooldownType
var stage : Genesis.CooldownStage
var frames : int = 0

func _init(_creature : CardOnField, _type : Genesis.CooldownType, _stage : Genesis.CooldownStage, _frames : int) -> void:
	self.creature = _creature
	self.type = _type
	self.stage = _stage
	self.frames = _frames

func _to_string() -> String:
	return "CreatureCooldownEffect(%s,%s,%s,%s)" % [self.creature, self.type, self.stage, self.frames]

func resolve(effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_REMAINING, self.frames)

	if self.stage != Genesis.CooldownStage.FINISH:
		if self.stage == Genesis.CooldownStage.START:
			creature_stats.set_statistic(Genesis.Statistic.JUST_STARTED_COOLDOWN, true)
			creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, true)
			var just_started_cooldown_expire_effect := SetStatisticEffect.new(
				creature_stats, Genesis.Statistic.JUST_STARTED_COOLDOWN, false
			)
			just_started_cooldown_expire_effect.requester = self.requester
			effect_resolver.request_effect(just_started_cooldown_expire_effect)
		else:
			if self.frames == 0:
				var end_effect := CreatureCooldownEffect.new(
					self.creature,
					self.type,
					Genesis.CooldownStage.FINISH,
					0
				)
				end_effect.requester = self.requester
				effect_resolver.request_effect(end_effect)
				return

		var tick_effect := CreatureCooldownEffect.new(
			self.creature,
			self.type,
			Genesis.CooldownStage.IN_PROGRESS,
			self.frames - 1
		)
		tick_effect.requester = self.requester
		effect_resolver.request_effect(tick_effect)
		
	else:

		creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, false)
		creature_stats.set_statistic(Genesis.Statistic.JUST_FINISHED_COOLDOWN, true)
		var just_finished_cooldown_expire_effect := SetStatisticEffect.new(
			creature_stats, Genesis.Statistic.JUST_FINISHED_COOLDOWN, false
		)
		just_finished_cooldown_expire_effect.requester = self.requester
		effect_resolver.request_effect(just_finished_cooldown_expire_effect)


