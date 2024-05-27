#class_name UIEventBus
extends Node

var action_queue : Array[Action] = []

signal reflect_action(action : Action)

func _process(_delta : float) -> void:
	for action in action_queue:
		reflect_action.emit(action)
	action_queue.clear()

func submit_action(action : Action) -> void:
	action_queue.push_back(action)
