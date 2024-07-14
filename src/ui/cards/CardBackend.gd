class_name CardBackend
extends Node

func _init(ci : ICardInstance) -> void:
	self.add_child(ci)
	self.add_child(IStatisticPossessor.new())
	self.add_child(IMoodPossessor.new())

	self.name = self._to_string()

func _to_string() -> String:
	return "CardBackend<%s>" % ICardInstance.id(self)