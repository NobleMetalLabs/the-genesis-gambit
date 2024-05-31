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
	return "CreatureAttackEffect(%s)" % self.creature