class_name CreatureSpawnEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureSpawnEffect",
		[
			CardBehaviorArgument.object("creature"),
			CardBehaviorArgument.bool("keep_stats", false),
			CardBehaviorArgument.bool("keep_mood", false),
		],
	)

