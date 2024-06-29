class_name NetworkPlayer
extends Resource

var uid : int
var player_name : StringName
var pack_stack : PackStack 

func _init(_uid : int, _player_name : StringName) -> void:
	self.uid = _uid
	self.player_name = _player_name
	self.pack_stack = PackStack.new()
