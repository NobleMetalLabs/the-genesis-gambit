class_name AllTargetsInAreaCBN
extends CardBehaviorNode

func _init() -> void:
	super("AllTargetsInArea",
		[CardBehaviorArgument.area("area")], 
		[CardBehaviorArgumentArray.from(
			CardBehaviorArgument.targetable("hits")
		)],
	)