class_name CreatureSpawnAction
extends CreatureAction

var position : Vector2

func _init(_creature : CardOnField, _position : Vector2) -> void:
	self.creature = _creature
	self.position = _position