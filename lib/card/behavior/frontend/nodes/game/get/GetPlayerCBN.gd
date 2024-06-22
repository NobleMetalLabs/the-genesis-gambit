class_name GetPlayerCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetPlayer",
		[
			CardBehaviorArgument.object("object")
		], 
		[
			CardBehaviorArgument.object("player")
		]
	)

