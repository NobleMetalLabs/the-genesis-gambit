class_name CompareCBN
extends CardBehaviorNode

func _init() -> void:
	super("Compare",
		[
			CardBehaviorArgument.variant("x"), 
			CardBehaviorArgument.variant("y"),
		],  
		[
			CardBehaviorArgument.bool("result")
		],
		[
			CardBehaviorArgument.indexed_options("domain",
				[
					CardBehaviorArgument.ArgumentType.BOOL,
					CardBehaviorArgument.ArgumentType.INT,
					CardBehaviorArgument.ArgumentType.FLOAT
				]
			),
			CardBehaviorArgument.indexed_options("operation",
				[
					"x == y", 
					"x < y",
					"x <= y", 
					"x >= y", 
					"x > y", 
					"x != y",
				]
			)
		]
	)

