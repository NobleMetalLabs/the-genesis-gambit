class_name GetEnemyCardsCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetEnemyCards",
		[], 
		[
			CardBehaviorArgumentArray.from(CardBehaviorArgument.object("cards"))
		]
	)

