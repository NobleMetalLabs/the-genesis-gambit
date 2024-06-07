class_name FireSignalCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.targetable("target"), 
			CardBehaviorArgument.string_name("signal"),
			CardBehaviorArgument.string_name("args?"),
		], 
		[]
	)

