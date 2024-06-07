class_name AllTargetsInAreaCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[CardBehaviorArgument.area("area")], 
		[CardBehaviorArgumentArray.targetable("hits")],
	)