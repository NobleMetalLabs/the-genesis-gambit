class_name SetStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("SetStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.variant("value"),
	],
	[],
	[
		CardBehaviorArgument.indexed_options("domain",
			[
				CardBehaviorArgument.ArgumentType.INT,
				CardBehaviorArgument.ArgumentType.FLOAT,
				CardBehaviorArgument.ArgumentType.BOOL,
				CardBehaviorArgument.ArgumentType.STRING_NAME,
			]
		),
		CardBehaviorArgument.tiered_indexed_options_statistic(),
	]
	)

