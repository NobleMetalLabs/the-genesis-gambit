class_name DeckRemoveCardEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("DeckRemoveCardEffect",
		[
			CardBehaviorArgument.object("player"),
			CardBehaviorArgument.object("card"),
			CardBehaviorArgument.indexed_options("reason",
				Genesis.LeaveHandReason.keys(),
			),
			CardBehaviorArgument.indexed_options("animation",
				Genesis.CardRemoveAnimation.keys(),
			),
		],
	)

