class_name CountCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.bool("pInput"), 
			CardBehaviorArgument.bool("sInput"),
			CardBehaviorArgument.int("delta"),
		], 
		[
			CardBehaviorArgument.int("result")
		]
	)

