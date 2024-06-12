class_name CreatureActivateEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureActivateEffect",
		[
			CardBehaviorArgument.object("creature"),
		], 
	)

