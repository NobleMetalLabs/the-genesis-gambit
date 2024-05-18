#class_name UIEventBussy
extends Node

var event_queue : Array[Dictionary] = []

signal event(data : Dictionary)

func _process(_delta : float) -> void:
	for event_dict in event_queue:
		event.emit(event_dict)
	event_queue.clear()

func submit_event(data : Dictionary) -> void:
	event_queue.push_back(data)
