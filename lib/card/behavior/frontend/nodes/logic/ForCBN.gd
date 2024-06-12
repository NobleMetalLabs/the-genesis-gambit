class_name ForCBN
extends CardBehaviorNode

func _init() -> void:
	super("For",
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.variant("array")), 
		],  
		[
			CardBehaviorArgument.variant("individual")
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
			CardBehaviorArgument.indexed_options("direction",
				[
					"forward",
					"reverse"
				]
			)
		]
	)

