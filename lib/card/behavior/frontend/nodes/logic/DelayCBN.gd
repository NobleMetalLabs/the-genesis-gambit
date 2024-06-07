class_name DelayCBN
extends CardBehaviorNode

func _init() -> void:
	super("Delay",
		[
			CardBehaviorArgument.bool("input"), 
			CardBehaviorArgument.int("length"),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

