class_name MostRecentAttackerCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[CardBehaviorArgument.targetable("subject")], 
		[CardBehaviorArgument.targetable("attacker")],
	)

