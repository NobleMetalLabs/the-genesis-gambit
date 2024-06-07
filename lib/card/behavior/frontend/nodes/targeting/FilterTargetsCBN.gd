class_name FilterTargetsCBN
extends CardBehaviorNode

#TODO: This will be a nightmare
func _init() -> void:
	super("FilterTargets",
	[
		CardBehaviorArgumentArray.from(
			CardBehaviorArgument.targetable("input"),
		),
		CardBehaviorArgument.string_name("field"),
		CardBehaviorArgument.variant("value", 
			[
				"int",
				"float",
				"StringName",
			]
		),
	], 
	[
		CardBehaviorArgumentArray.from(
			CardBehaviorArgument.targetable("result"),
		),
	]) 
