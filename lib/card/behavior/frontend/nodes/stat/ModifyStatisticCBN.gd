class_name ModifyStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("ModifyStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.string_name("stat_name"),
		CardBehaviorArgument.variant("value"),
	], 
	[],
	[
		CardBehaviorArgument.indexed_options("domain",
			[
				CardBehaviorArgument.ArgumentType.INT,
				CardBehaviorArgument.ArgumentType.FLOAT,
			]
		),
	]
	)

