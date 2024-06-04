class_name CreatureAttackEffect
extends CreatureEffect

var target : CardOnField
var damage : int

static func from_action(_action : CreatureAttackAction) -> CreatureAttackEffect:
	return CreatureAttackEffect.new(_action.creature, _action.target, _action.damage)

func _init(_creature : CardOnField, _target : CardOnField, _damage : int) -> void:
	self.creature = _creature
	self.target = _target
	self.damage = _damage

func _to_string() -> String:
	return "CreatureAttackEffect(%s, %s, %d)" % [self.creature, self.target, self.damage]

func resolve(effect_resolver : EffectResolver) -> void:
	print("%s attacked %s" % [self.creature, self.target])
	var creature_stats := IStatisticPossessor.id(self.creature)
	var target_stats := IStatisticPossessor.id(self.target)

	creature_stats.set_statistic(Genesis.Statistic.JUST_ATTACKED, true)
	var just_attacked_expire_effect := SetStatisticEffect.new(creature_stats, Genesis.Statistic.JUST_ATTACKED, false)
	just_attacked_expire_effect.requester = self.requester
	effect_resolver.request_effect(just_attacked_expire_effect)

	var attack_cooldown_start_effect := CreatureCooldownEffect.new(
		self.creature,
		Genesis.CooldownType.ATTACK,
		Genesis.CooldownStage.START,
		3 #TODO: get this value from speed
	)
	attack_cooldown_start_effect.requester = self.requester
	effect_resolver.request_effect(attack_cooldown_start_effect)

	target_stats.set_statistic(Genesis.Statistic.WAS_JUST_ATTACKED, true)
	var was_just_attacked_expire_effect := SetStatisticEffect.new(target_stats, Genesis.Statistic.WAS_JUST_ATTACKED, false)
	was_just_attacked_expire_effect.requester = self.requester
	effect_resolver.request_effect(was_just_attacked_expire_effect)

	var attack_swing_tween : Tween = Router.get_tree().create_tween()
	attack_swing_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "rotation_degrees", 20, 0.05)
	attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", -20, 0.1)
	attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", 0, 0.2)
	var attack_grow_tween : Tween = Router.get_tree().create_tween()
	attack_grow_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "scale", Vector2.ONE * 1.05, 0.1)
	attack_grow_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT).tween_property(self.creature, "scale", Vector2.ONE, 0.5)

	var damage_flash_tween : Tween = Router.get_tree().create_tween()
	damage_flash_tween.tween_property(self.target, "modulate", Color(1, 0, 0, 1), 0)
	damage_flash_tween.tween_property(self.target, "modulate", Color(1, 1, 1, 1), 0.5)
