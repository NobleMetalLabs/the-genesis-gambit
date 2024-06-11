class_name RemoveStatisticMoodEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("RemoveStatisticMoodEffect",
		[
			CardBehaviorArgument.object("object"),
			CardBehaviorArgument.object("mood"),
		],
	)

