class_name GetEffectsCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetCards",
		[], 
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.object("effects"))
		]
	)

