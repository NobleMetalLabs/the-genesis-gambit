class_name CompareCBN
extends CardBehaviorNode

func _init() -> void:
	super("Compare",
		[
			CardBehaviorArgument.bool("a"), 
			CardBehaviorArgument.bool("b"),
		],  
		[
			CardBehaviorArgument.bool("result")
		],
		[
			CardBehaviorArgument.string_name_options("operation",
				[
					"AND", 
					"OR", 
					"XOR",
					"NAND", 
					"NOR", 
					"XNOR",
				]
			)
		]
	)

