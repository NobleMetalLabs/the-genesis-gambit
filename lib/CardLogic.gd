@icon("res://lib/CardLogic.png")
class_name CardLogic
extends RefCounted

var owner : ICardInstance

func _init(_owner : ICardInstance) -> void:
	self.owner = _owner