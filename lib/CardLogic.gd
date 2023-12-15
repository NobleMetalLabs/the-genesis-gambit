@icon("res://lib/CardLogic.png")
class_name CardLogic
extends Object

var card_instance : CardInstance
var event_handlers : Dictionary #[StringName (event), Callable] 

func _init(_event_handlers : Dictionary) -> void:
	event_handlers = _event_handlers

func process_event(event_name : String, data : Dictionary) -> void:
	if event_handlers.has(event_name):
		event_handlers.get(event_name).call(data)