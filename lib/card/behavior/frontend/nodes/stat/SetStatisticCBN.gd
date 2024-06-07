class_name SetStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super(
	[
		CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.string_name("stat_name"),
		CardBehaviorArgument.string_name("amount"),
	], [],
	)

