class_name CardBehaviorEdge
extends Serializeable

var start_node : CardBehaviorNodeInstance
var start_port : int
var end_node : CardBehaviorNodeInstance
var end_port : int

func _init(_start_node : CardBehaviorNodeInstance, _start_port : int, _end_node : CardBehaviorNodeInstance, _end_port : int) -> void:
	self.start_node = _start_node
	self.start_port = _start_port
	self.end_node = _end_node
	self.end_port = _end_port