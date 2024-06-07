class_name CardBehaviorArgument
extends Resource

var type : StringName
var name : StringName
var meta : Dictionary

func _init() -> void:
	push_error("CardBehaviorArgument is not to be instanced manually. Use the static functions to create new instances.")

static func variant(_name : StringName, _accepted_types : Array[StringName]) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "Variant"
	argument.name = _name
	argument.meta = {
		"accepted_types" : _accepted_types
	}
	return argument

static func int(_name : StringName) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "int"
	argument.name = _name
	return argument

static func float(_name : StringName) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "float"
	argument.name = _name
	return argument

static func bool(_name : StringName) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "bool"
	argument.name = _name
	return argument

static func string_name(_name : StringName) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "StringName"
	argument.name = _name
	return argument

static func string_name_options(_name : StringName, _options : Array[StringName]) -> CardBehaviorArgument:
	var argument : CardBehaviorArgument = CardBehaviorArgument.new()
	argument.type = "StringName"
	argument.name = _name
	argument.meta = {
		"options" : _options
	}
	return argument