class_name GetStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.string_name("stat_name"),
	], 
	[
		CardBehaviorArgument.variant("value")
	],
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

