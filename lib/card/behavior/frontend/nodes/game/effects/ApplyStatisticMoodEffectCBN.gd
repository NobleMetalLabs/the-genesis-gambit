class_name ApplyStatisticMoodEffectCBN
extends CardBehaviorNode

func _init() -> void:
	super("ApplyStatisticMoodEffect",
		[
			CardBehaviorArgument.object("object"),
			CardBehaviorArgument.indexed_options("effect",
				Mood.MoodEffect.keys()
			),
			CardBehaviorArgument.int("amount")
		], 
		[],
		[
			CardBehaviorArgument.tiered_indexed_options_statistic()
		]
	)

