class_name CreatureAttackAction
extends CreatureAction

var target : ITargetable
var damage : int

func _init(_creature : ICardInstance, _target : ITargetable, _damage : int) -> void:
	self.creature = _creature
	self.target = _target
	self.damage = _damage

func _to_string() -> String:
	return "CreatureAttackAction(%s)" % self.creature

func to_effect() -> CreatureAttackEffect:
	return CreatureAttackEffect.new(self, creature, target, damage)