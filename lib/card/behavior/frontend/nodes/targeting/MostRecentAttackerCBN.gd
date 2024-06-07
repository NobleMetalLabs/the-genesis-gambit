class_name MostRecentAttackerCBN
extends CardBehaviorNode

func _init() -> void:
	super("MostRecentAttacker",
		[
			#CardBehaviorArgument.targetable("subject")
		], 
		[
			#CardBehaviorArgument.targetable("attacker")
		],
	)

