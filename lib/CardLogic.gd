@icon("res://lib/CardLogic.png")
class_name CardLogic
extends Object

@export var event_handlers : Dictionary #[StringName (event), Callable] 

func _init(_event_handlers : Dictionary) -> void:
	event_handlers = _event_handlers