class_name HandAddCardEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("HandAddCardEffect",
		[
			CardBehaviorArgument.object("player"),
			CardBehaviorArgument.bool("from_deck", true),
			CardBehaviorArgument.bool("specific_card", false),
			CardBehaviorArgument.indexed_options("card",
				CardDB.cards.map(
					func get_card_name(c : CardMetadata) -> String: return c.name
				)
			),
		],
	)

