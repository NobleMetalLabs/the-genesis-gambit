class_name CreatureSpawnAction
extends Action

var card : ICardInstance

static func setup(_card : ICardInstance) -> CreatureSpawnAction:
	var csa := CreatureSpawnAction.new()
	csa.card = _card
	return csa

func _init() -> void: pass

func _to_string() -> String:
	return "CreatureSpawnAction(%s,%s)" % [self.creature, self.position]

func to_effect() -> CreatureSpawnEffect:
	return CreatureSpawnEffect.new(self, card)