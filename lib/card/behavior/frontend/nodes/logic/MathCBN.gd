class_name MathCBN
extends CardBehaviorNode

func _init() -> void:
	super(
		[
			CardBehaviorArgument.variant("num1",
				[
					"int",
					"float",
				]
			), 
			CardBehaviorArgument.variant("num2",
				[
					"int",
					"float",
				]
			),
			CardBehaviorArgument.string_name_options("operation",
				[
					"add", 
					"subtract", 
					"multiply", 
					"divide", 
					"modulo",
					"power",
				]
			),
		], 
		[
			CardBehaviorArgument.variant("result",
				[
					"int",
					"float",
				]
			)
		]
	)

