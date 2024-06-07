class_name CardBehaviorNode
extends Resource

var inputs : Array[CardBehaviorArgument]
var outputs : Array[CardBehaviorArgument]

func _init(_inputs : Array[CardBehaviorArgument], _outputs : Array[CardBehaviorArgument]) -> void:
	inputs = _inputs
	outputs = _outputs