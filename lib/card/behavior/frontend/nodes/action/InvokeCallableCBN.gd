class_name InvokeCallableCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.targetable("target"), 
			CardBehaviorArgument.string_name("name"),
			CardBehaviorArgument.string_name("args?"),
		], 
		[]
	)

