class_name CreatureSpawnEffect
extends CreatureEffect

var position : Vector2

func _init(_creature : CardOnField, _position : Vector2) -> void:
	self.creature = _creature
	self.position = _position

func _to_string() -> String:
	return "CreatureSpawnEffect(%s,%s)" % [self.creature, self.position]