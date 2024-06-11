class_name CreatureAttackEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureAttackEffect",
		[
			CardBehaviorArgument.object("creature"),
			CardBehaviorArgument.object("target"),
			CardBehaviorArgument.int("damage")
		],
	)

