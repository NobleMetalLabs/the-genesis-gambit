class_name SetObjectPropertyCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetObjectProperty",
		[
			CardBehaviorArgument.object("object"),
			CardBehaviorArgument.string_name("property"),
			CardBehaviorArgument.variant("value")
		], 
		[],
		[
			CardBehaviorArgument.indexed_options("domain",
				[
					CardBehaviorArgument.ArgumentType.INT,
					CardBehaviorArgument.ArgumentType.FLOAT,
					CardBehaviorArgument.ArgumentType.BOOL,
					CardBehaviorArgument.ArgumentType.STRING_NAME,
					CardBehaviorArgument.ArgumentType.OBJECT,
				]
			),
		]
	)

