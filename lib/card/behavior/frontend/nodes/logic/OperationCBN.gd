class_name OperationCBN
extends CardBehaviorNode

func _init() -> void:
	super("Operation",
		[
			CardBehaviorArgument.bool("num1"), 
			CardBehaviorArgument.bool("num2"),
			CardBehaviorArgument.string_name_options("operation",
				[
					"not",
					"and",
					"or",
					"xor",
				]
			),
		], 
		[
			CardBehaviorArgument.bool("result")
		]
	)

