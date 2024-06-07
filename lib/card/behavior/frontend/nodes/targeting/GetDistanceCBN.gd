class_name GetDistanceCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetDistance",
		[
			#CardBehaviorArgument.targetable("target1"),
			#CardBehaviorArgument.targetable("target2")
		], 
		[
			CardBehaviorArgument.float("distance")
		]
	) 
