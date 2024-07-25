class_name CreatureCooldownEffect
extends CreatureEffect

var stage : Genesis.CooldownStage
var frames : int = 0
var callback : Callable = Callable()

func _init(_requester : Object, _creature : ICardInstance, _stage : Genesis.CooldownStage, _frames : int, _callback : Callable = Callable()) -> void:
	self.requester = _requester
	self.creature = _creature
	self.stage = _stage
	self.frames = _frames
	self.callback = _callback

func _to_string() -> String:
	return "CreatureCooldownEffect(%s,%s,%s,%s)" % [self.creature, self.stage, self.frames, self.callback]

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	creature_stats.set_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_REMAINING, self.frames)

	if self.stage != Genesis.CooldownStage.FINISH:
		if self.stage == Genesis.CooldownStage.START:
			creature_stats.set_statistic(Genesis.Statistic.JUST_STARTED_COOLDOWN, true)
			creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, true)
			creature_stats.set_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_LENGTH, self.frames)
			_effect_resolver.request_effect(SetStatisticEffect.new(
				self.requester, creature_stats, Genesis.Statistic.JUST_STARTED_COOLDOWN, false
			))
		else:
			if self.frames == 0:
				_effect_resolver.request_effect(CreatureCooldownEffect.new(
					self.requester,
					self.creature,
					Genesis.CooldownStage.FINISH,
					0,
					self.callback
				))
				return


		_effect_resolver.request_effect(CreatureCooldownEffect.new(
			self.requester,
			self.creature,
			Genesis.CooldownStage.IN_PROGRESS,
			self.frames - 1,
			self.callback
		))
		
	else:

		creature_stats.set_statistic(Genesis.Statistic.IS_IN_COOLDOWN, false)
		creature_stats.set_statistic(Genesis.Statistic.JUST_FINISHED_COOLDOWN, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, creature_stats, Genesis.Statistic.JUST_FINISHED_COOLDOWN, false
		))

		if self.callback.is_valid():
			self.callback.call()


