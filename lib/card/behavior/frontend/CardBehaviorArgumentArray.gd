class_name CardBehaviorArgumentArray
extends CardBehaviorArgument

func _init(static_instant : bool = false) -> void:
	if not static_instant:
		push_error("CardBehaviorArgumentArray is not to be instanced manually. Use the static functions to create new instances.")

static func from(_arg : CardBehaviorArgument) -> CardBehaviorArgumentArray:
	var arg := CardBehaviorArgumentArray.new(true)
	arg.name = _arg.name
	arg.type = _arg.type
	arg.meta = _arg.meta

	return arg
