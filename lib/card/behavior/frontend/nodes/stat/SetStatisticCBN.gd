class_name SetStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("SetStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.string_name("stat_name"),
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

