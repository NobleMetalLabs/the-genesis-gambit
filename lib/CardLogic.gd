@icon("res://lib/CardLogic.png")
class_name CardLogic
extends Object

var owner : CardInstance
var description : String
var event_handlers : Dictionary #[StringName (event), Callable] 

func process_event(event_name : String, data : Dictionary) -> void:
	if event_handlers.has(event_name):
		event_handlers.get(event_name).call(data)