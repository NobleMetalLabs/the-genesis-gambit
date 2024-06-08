class_name MathCBN
extends CardBehaviorNode

func _init() -> void:
	super("Math",
		[
			CardBehaviorArgument.variant("x"), 
			CardBehaviorArgument.variant("y"),
		],
		[
			CardBehaviorArgument.variant("result")
		],
		[
			CardBehaviorArgument.indexed_options("domain",
				[
					CardBehaviorArgument.ArgumentType.INT,
					CardBehaviorArgument.ArgumentType.FLOAT
				]
			),
			CardBehaviorArgument.indexed_options("operation",
				[
					"add", 
					"subtract", 
					"multiply", 
					"divide", 
					"modulo",
					"power",
				]
			)
		]
	)

