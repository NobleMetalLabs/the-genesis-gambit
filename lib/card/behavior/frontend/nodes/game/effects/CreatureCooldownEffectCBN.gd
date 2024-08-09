class_name CreatureCooldownEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("CreatureCooldownEffect",
		[
			CardBehaviorArgument.object("creature"),
			# CardBehaviorArgument.indexed_options("stage",
			# 	Genesis.CooldownStage.keys()
			# ),
			CardBehaviorArgument.int("frames")
		],
	)
