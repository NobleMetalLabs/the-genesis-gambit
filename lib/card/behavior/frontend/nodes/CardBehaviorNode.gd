class_name CardBehaviorNode
extends Resource

var name : String 
var input_args : Array[CardBehaviorArgument]
var option_args : Array[CardBehaviorArgument]
var output_args : Array[CardBehaviorArgument]

func _init(_name : String, _inputs : Array[CardBehaviorArgument], _outputs : Array[CardBehaviorArgument], _options : Array[CardBehaviorArgument] = []) -> void:
	name = _name
	input_args = _inputs
	output_args = _outputs
	option_args = _options
	_variant_check()

func _variant_check() -> void:
	var has_variant : bool = false
	for arg : CardBehaviorArgument in input_args:
		if arg.type == CardBehaviorArgument.ArgumentType.VARIANT:
			has_variant = true
			break
	for arg : CardBehaviorArgument in output_args:
		if arg.type == CardBehaviorArgument.ArgumentType.VARIANT:
			has_variant = true
			break
	if not has_variant: return
	
	if not option_args.is_empty():
		var first_option : CardBehaviorArgument = option_args[0]
		if first_option.type == CardBehaviorArgument.ArgumentType.INT and first_option.name == "domain":
			return
	push_error("CardBehaviorNode: To use arguments of Variant type, the first option must be a \"domain\" `indexed_options`.")
