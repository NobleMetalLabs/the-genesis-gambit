class_name HandBurnHandEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("HandBurnHandEffect",
		[
			CardBehaviorArgument.object("player"),
		],
	)

