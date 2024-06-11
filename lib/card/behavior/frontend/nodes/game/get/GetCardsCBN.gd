class_name GetCardsCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetCards",
		[], 
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.object("cards"))
		]
	)

