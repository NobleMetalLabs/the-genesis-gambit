class_name GetFriendlyCardsCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetFriendlyCards",
		[], 
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.object("cards"))
		]
	)

