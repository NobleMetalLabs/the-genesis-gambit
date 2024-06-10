class_name ModifyStatisticCBN
extends CardBehaviorNode

func _init() -> void:
	super("ModifyStatistic",
	[
		#CardBehaviorArgument.targetable("target"), 
		CardBehaviorArgument.tiered_indexed_options_statstic(),
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

