@icon("res://lib/CardLogic.png")
class_name CardLogic
extends RefCounted

var instance_owner : ICardInstance

func _init(_owner : ICardInstance) -> void:
	self.instance_owner = _owner