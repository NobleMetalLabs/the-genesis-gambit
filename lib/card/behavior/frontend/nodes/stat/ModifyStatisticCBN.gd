class_name ModifyStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super(
	[
		CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.string_name("stat_name"),
		CardBehaviorArgument.string_name("amount"),
	], [],
	)

