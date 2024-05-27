class_name GamefieldState
extends Resource

var players : Array[Player]

func _init(_players : Array[Player]) -> void:
	self.players = _players