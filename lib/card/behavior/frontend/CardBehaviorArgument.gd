class_name CardBehaviorArgument
extends Resource

var type : ArgumentType
var name : StringName
var meta : Dictionary

enum ArgumentType {
	VARIANT,
	INT,
	FLOAT,
	BOOL,
	STRING_NAME,
	AREA,
	TARGETABLE
}

static var ArgumentColors : Dictionary = {
	ArgumentType.VARIANT : Color.WHITE,
	ArgumentType.INT : Color.CORNFLOWER_BLUE,
	ArgumentType.FLOAT : Color.DODGER_BLUE,
	ArgumentType.BOOL : Color.LIME_GREEN,
	ArgumentType.STRING_NAME : Color.GOLDENROD,
	ArgumentType.AREA : Color.DARK_ORCHID,
	ArgumentType.TARGETABLE : Color.CRIMSON,
}

func _init(static_instant : bool = false) -> void:
	if not static_instant:
		push_error("CardBehaviorArgument is not to be instanced manually. Use the static functions to create new instances.")

static func variant(_name : StringName, _accepted_types : Array[StringName]) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.VARIANT
	argument.name = _name
	argument.meta = {
		"accepted_types" : _accepted_types
	}
	return argument

static func int(_name : StringName) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.INT
	argument.name = _name
	argument.meta = {}
	return argument

static func float(_name : StringName) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.FLOAT
	argument.name = _name
	argument.meta = {}
	return argument

static func bool(_name : StringName) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.BOOL
	argument.name = _name
	argument.meta = {}
	return argument

static func string_name(_name : StringName) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.STRING_NAME
	argument.name = _name
	argument.meta = {}
	return argument

static func string_name_options(_name : StringName, _options : Array[StringName]) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.STRING_NAME
	argument.name = _name
	argument.meta = {
		"options" : _options
	}
	return argument