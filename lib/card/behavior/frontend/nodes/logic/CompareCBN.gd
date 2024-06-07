class_name CompareCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.bool("a"), 
			CardBehaviorArgument.bool("b"),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

