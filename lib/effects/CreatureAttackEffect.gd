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
		IMoodPossessor.id(self.creature).apply_mood(BoredomMood.new(self.creature))
		self.resolve_status = ResolveStatus.FAILED
		return

	creature_stats.set_statistic(Genesis.Statistic.JUST_ATTACKED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, creature_stats, Genesis.Statistic.JUST_ATTACKED, false
	))
	
	var target_stats := IStatisticPossessor.id(self.target)
	target_stats.set_statistic(Genesis.Statistic.WAS_JUST_ATTACKED, true)
	_effect_resolver.request_effect(SetStatisticEffect.new(
		self.requester, target_stats, Genesis.Statistic.WAS_JUST_ATTACKED, false
	))

	target_stats.set_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED_BY, ICardInstance.id(self.creature))
	creature_stats.set_statistic(Genesis.Statistic.MOST_RECENT_ATTACKED, ICardInstance.id(self.target))

	#var attack_swing_tween : Tween = Router.get_tree().create_tween()
	#attack_swing_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "rotation_degrees", 20, 0.05)
	#attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", -20, 0.1)
	#attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", 0, 0.2)
	#var attack_grow_tween : Tween = Router.get_tree().create_tween()
	#attack_grow_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "scale", Vector2.ONE * 1.05, 0.1)
	#attack_grow_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT).tween_property(self.creature, "scale", Vector2.ONE, 0.5)
#
	#var damage_flash_tween : Tween = Router.get_tree().create_tween()
	#damage_flash_tween.tween_property(self.target, "modulate", Color(1, 0, 0, 1), 0)
	#damage_flash_tween.tween_property(self.target, "modulate", Color(1, 1, 1, 1), 0.5)
