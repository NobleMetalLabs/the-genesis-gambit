class_name GetEffectsCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetEffects",
		[], 
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.object("effects"))
		]
	)

