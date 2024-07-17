class_name CardBehaviorNodeInstance
extends Serializeable

var config : CardBehaviorNode
var argument_values : Dictionary #[StringName, Variant]

func _init(_config : CardBehaviorNode, _arg_values : Dictionary = {}) -> void:
	self.config = _config
	
	for arg : CardBehaviorArgument in _config.option_args:
		argument_values[arg.name] = arg.default
	argument_values.merge(_arg_values, true)