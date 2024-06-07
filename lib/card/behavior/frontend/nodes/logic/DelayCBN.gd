class_name DelayCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.bool("input"), 
			CardBehaviorArgument.int("length"),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

