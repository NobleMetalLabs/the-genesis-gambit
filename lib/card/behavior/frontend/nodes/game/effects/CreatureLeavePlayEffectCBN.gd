class_name CreatureLeavePlayEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureLeavePlayEffect",
		[
			CardBehaviorArgument.object("creature"),
			CardBehaviorArgument.object("source"),
			CardBehaviorArgument.indexed_options("reason",
				Genesis.LeavePlayReason.keys()
			),
		],
	)

