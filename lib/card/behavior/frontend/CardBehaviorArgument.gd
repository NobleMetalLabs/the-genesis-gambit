class_name CardBehaviorArgument
extends Resource

var type : ArgumentType
var name : StringName
var meta : Dictionary
var default : Variant

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

static func variant(_name : StringName) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.VARIANT
	argument.name = _name
	argument.meta = {}
	argument.default = null
	return argument

static func int(_name : StringName, _default : int = 0) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.INT
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument

static func float(_name : StringName, _default : float = 0.0) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.FLOAT
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument

static func bool(_name : StringName, _default : bool = false) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.BOOL
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument

static func string_name(_name : StringName, _default : StringName = "") -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.STRING_NAME
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument

static func string_name_options(_name : StringName, _options : Array[StringName]) -> CardBehaviorArgument:
	if _options.is_empty():
		push_error("CardBehaviorArgument.string_name_options: _options cannot be empty.")
		return null
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.STRING_NAME
	argument.name = _name
	argument.default = _options[0]
	argument.meta = {
		"options" : _options
	}
	return argument

static func indexed_options(_name : StringName, _options : Array) -> CardBehaviorArgument:
	if _options.is_empty():
		push_error("CardBehaviorArgument.indexed_options: _options cannot be empty.")
		return null
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.INT
	argument.name = _name
	argument.default = 0
	argument.meta = {
		"options" : _options
	}
	return argument

static func area(_name : StringName, _default := Area2D.new()) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.AREA
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument

static func targetable(_name : StringName, _default : ITargetable = null) -> CardBehaviorArgument:
	var argument := CardBehaviorArgument.new(true)
	argument.type = ArgumentType.TARGETABLE
	argument.name = _name
	argument.meta = {}
	argument.default = _default
	return argument