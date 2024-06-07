class_name EdgeCBN
extends CardBehaviorNode

func _init() -> void:
	super("Edge",
		[
			CardBehaviorArgument.bool("input"), 
			CardBehaviorArgument.int("length"),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

