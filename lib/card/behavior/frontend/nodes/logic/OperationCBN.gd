class_name OperationCBN
extends CardBehaviorNode

func _init() -> void:
	super("Operation",
		[
			CardBehaviorArgument.bool("a"), 
			CardBehaviorArgument.bool("b"),
		],  
		[
			CardBehaviorArgument.bool("c")
		],
		[
			CardBehaviorArgument.indexed_options("operator",
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

