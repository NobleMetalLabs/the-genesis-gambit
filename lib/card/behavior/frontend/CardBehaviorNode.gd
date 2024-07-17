class_name CardBehaviorNode
extends Serializeable

var name : String 
var input_args : Array[CardBehaviorArgument]
var option_args : Array[CardBehaviorArgument]
var output_args : Array[CardBehaviorArgument]

func _init(_name : String, _inputs : Array[CardBehaviorArgument], _outputs : Array[CardBehaviorArgument] = [], _options : Array[CardBehaviorArgument] = []) -> void:
	name = _name
	var run_arg : Array[CardBehaviorArgument] = [CardBehaviorArgument.bool("run")]
	input_args = run_arg + _inputs
	output_args = run_arg + _outputs
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

static func load_node(_name : String) -> CardBehaviorNode:
	return load(load_nodes()[_name + "CBN"]).new()

static func load_nodes(path : String = "res://lib/card/behavior/frontend/nodes/") -> Dictionary: #[String..., Path]
	var nodes_dir : DirAccess = DirAccess.open(path)
	if nodes_dir == null: return {}
	var output : Dictionary = {}
	for directory in nodes_dir.get_directories():
		output.merge(load_nodes("%s/%s" % [path, directory]))
	for file in nodes_dir.get_files():
		if not file.get_basename().ends_with("CBN"):
			continue
		var node_name : String = file.get_basename()
		if node_name == "null": continue
		output[node_name] = "%s/%s" % [path, file]
	return output