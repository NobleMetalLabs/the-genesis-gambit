class_name SetStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("SetStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.tiered_indexed_options_statstic(),
		CardBehaviorArgument.variant("amount"),
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
	]
	)

