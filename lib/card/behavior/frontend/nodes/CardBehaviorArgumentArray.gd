class_name CardBehaviorArgumentArray
extends CardBehaviorArgument

func _init() -> void:
	push_error("CardBehaviorArgumentArray is not to be instanced manually. Use the static functions to create new instances.")

static func int(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.int(_name) as CardBehaviorArgumentArray

static func float(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.float(_name) as CardBehaviorArgumentArray

static func bool(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.bool(_name) as CardBehaviorArgumentArray

static func string_name(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.string_name(_name) as CardBehaviorArgumentArray

static func area(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.area(_name) as CardBehaviorArgumentArray

static func targetable(_name : StringName) -> CardBehaviorArgumentArray:
	return CardBehaviorArgument.targetable(_name) as CardBehaviorArgumentArray