class_name HandRemoveCardEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("HandRemoveCardEffect",
		[
			CardBehaviorArgument.object("player"),
			CardBehaviorArgument.object("card"),
			CardBehaviorArgument.indexed_options("reason",
				Genesis.LeaveHandReason.keys()
			),
			CardBehaviorArgument.indexed_options("animation",
				Genesis.CardRemoveAnimation.keys()
			),
		],
	)

