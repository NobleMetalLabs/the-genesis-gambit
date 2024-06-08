class_name CardBehaviorNodeInstance
extends Resource

var config : CardBehaviorNode
var option_values : Dictionary #[StringName, Variant]

func _init(_config : CardBehaviorNode) -> void:
	self.config = _config

	for arg : CardBehaviorArgument in _config.option_args:
		option_values[arg.name] = arg.default