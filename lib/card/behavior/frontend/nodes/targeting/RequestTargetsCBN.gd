class_name RequestTargetsCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[], 
		[CardBehaviorArgumentArray.targetable("attacker")],
	)

