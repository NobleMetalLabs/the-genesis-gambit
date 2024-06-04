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

	target_stats.set_statistic(Genesis.Statistic.WAS_JUST_ATTACKED, true)
	var was_just_attacked_expire_effect := SetStatisticEffect.new(target_stats, Genesis.Statistic.WAS_JUST_ATTACKED, false)
	was_just_attacked_expire_effect.requester = self.requester
	effect_resolver.request_effect(was_just_attacked_expire_effect)