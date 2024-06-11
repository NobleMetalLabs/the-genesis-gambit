class_name DeckAddCardEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("DeckAddCardEffect",
		[
			CardBehaviorArgument.object("player"),
			CardBehaviorArgument.object("card"),
			CardBehaviorArgument.bool("as marked", true),
			CardBehaviorArgument.bool("keep stats", false),
			CardBehaviorArgument.bool("keep moods",	false),
		],
	)

