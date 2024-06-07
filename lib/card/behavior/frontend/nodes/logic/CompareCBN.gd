class_name CompareCBN
extends CardBehaviorNode

func _init() -> void:
	super("Compare",
		[
			CardBehaviorArgument.bool("a"), 
			CardBehaviorArgument.bool("b"),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

