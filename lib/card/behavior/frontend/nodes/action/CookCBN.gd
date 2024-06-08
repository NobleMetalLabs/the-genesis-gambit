class_name CookCBN
extends CardBehaviorNode

var referenced_node : CardBehaviorNodeInstance

func _init() -> void:
	super("Cook", 1,
		[
			CardBehaviorArgument.bool("cook"), 
		], 
		[]
	)