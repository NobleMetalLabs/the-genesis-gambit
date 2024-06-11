class_name CreatureTargetEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureTargetEffect",
		[
			CardBehaviorArgument.object("creature"),
			CardBehaviorArgument.object("target"),
		],
	)

