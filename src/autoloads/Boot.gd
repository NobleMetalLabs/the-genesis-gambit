#class_name Boot
extends Node

func _ready() -> void:
	GlobalCommandServerParsers.register_global_parsers()