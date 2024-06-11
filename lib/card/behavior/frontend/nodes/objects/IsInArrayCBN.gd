class_name IsInArrayCBN
extends CardBehaviorNode

func _init() -> void:
	super("IsInArray",
		[
			CardBehaviorArgument.variant("item"),
			CardBehaviorArgumentArray.from(CardBehaviorArgument.variant("array")), 
		],  
		[
			CardBehaviorArgument.bool("result")
		],
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
		]
	)
