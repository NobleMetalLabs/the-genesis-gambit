class_name CreatureAttackEffect
extends CreatureEffect

var target : ICardInstance
var damage : int

func _init(_requester : Object, _creature : ICardInstance, _target : ICardInstance, _damage : int) -> void:
	self.requester = _requester
	self.creature = _creature
	self.target = _target
	self.damage = _damage

func _to_string() -> String:
	return "CreatureAttackEffect(%s, %s, %d)" % [self.creature, self.target, self.damage]

func resolve(_effect_resolver : EffectResolver) -> void:
	var creature_stats := IStatisticPossessor.id(self.creature)
	
	var request_next_attack : Callable = func request_next_attack() -> void:
		_effect_resolver.request_effect(
			CreatureAttackEffect.new(
				self.requester,
				self.creature,
				creature_stats.get_statistic(Genesis.Statistic.TARGET),
				creature_stats.get_statistic(Genesis.Statistic.STRENGTH)
			)
		)

	_effect_resolver.request_effect(CooldownEffect.new(
		self.requester,
		creature_stats,
		Genesis.CooldownType.ATTACK,
		Genesis.speed_value_to_cooldown_frame_count(creature_stats.get_statistic(Genesis.Statistic.SPEED)),
		request_next_attack
	))
	

	if target == null:
		_effect_resolver.request_effect(ApplyMoodEffect.new(
			self.requester,
			IMoodPossessor.id(self.creature),
			BoredomMood.new(self.creature)
		))
		
		self.resolve_status = ResolveStatus.FAILED
		return
	
	var target_stats := IStatisticPossessor.id(self.target)
	if not target_stats.get_statistic(Genesis.Statistic.CAN_BE_ATTACKED): return
	
	creature_stats.set_statistic(Genesis.Statistic.JUST_ATTACKED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.JUST_ATTACKED, false
	))
	
	target_stats.set_statistic(Genesis.Statistic.WAS_JUST_ATTACKED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, target_stats, Genesis.Statistic.WAS_JUST_ATTACKED, false
	))

	target_stats.set_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED_BY, ICardInstance.id(self.creature))
	creature_stats.set_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED, ICardInstance.id(self.target))

	target_stats.modify_statistic(Genesis.Statistic.HEALTH, -damage)
	if target_stats.get_statistic(Genesis.Statistic.HEALTH) <= 0:
		if target_stats.get_statistic(Genesis.Statistic.CAN_BE_KILLED):
			_effect_resolver.request_effect(CreatureLeavePlayEffect.new(
				self.requester,
				self.target,
				self.creature,
				Genesis.LeavePlayReason.DIED
			))
		
