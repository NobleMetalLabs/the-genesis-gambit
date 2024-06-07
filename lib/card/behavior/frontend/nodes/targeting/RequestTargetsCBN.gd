class_name RequestTargetsCBN
extends CardBehaviorNode

func _init() -> void:
	super("RequestTargets",
		[], 
		[CardBehaviorArgumentArray.from(
			CardBehaviorArgument.targetable("attacker")
		)],
	)

