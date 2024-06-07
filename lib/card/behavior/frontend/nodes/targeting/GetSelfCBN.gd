class_name GetSelfCBN
extends CardBehaviorNode

func _init() -> void:
	super("GetSelf",
		[], 
		[
			#CardBehaviorArgument.targetable("self")
		]
	)

# func process(inputs : Array) -> Array:
	#return [api.get_self()]
