class_name SetStatisticEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("SetStatisticEffect",
		[
			CardBehaviorArgument.object("object"),
			CardBehaviorArgument.variant("value"),
		], 
		[],
		[
			CardBehaviorArgument.indexed_options("domain",
				[
					CardBehaviorArgument.ArgumentType.BOOL,
					CardBehaviorArgument.ArgumentType.INT,
					CardBehaviorArgument.ArgumentType.FLOAT,
					CardBehaviorArgument.ArgumentType.STRING_NAME,
					CardBehaviorArgument.ArgumentType.OBJECT,
				]
			),
			CardBehaviorArgument.tiered_indexed_options_statistic(),
		]
	)

