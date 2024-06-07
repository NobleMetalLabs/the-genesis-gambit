class_name CBEditorGraphNode
extends GraphNode

var node_internal : CardBehaviorNodeInstance

func _init(_node_internal : CardBehaviorNodeInstance, _rect : Rect2) -> void:
	self.node_internal = _node_internal
	self.position = _rect.position
	self.size = _rect.size

	self.title = _node_internal.node_logic.name

	print(_node_internal)
	print(_node_internal.node_logic)
	print(_node_internal.node_logic.input_args)
	print(_node_internal.node_logic.output_args)

	var input_args : Array[CardBehaviorArgument] = _node_internal.node_logic.input_args
	var output_args : Array[CardBehaviorArgument] = _node_internal.node_logic.output_args

	for i in range(max(input_args.size(), output_args.size())):
		var slot_cont := Control.new()
		slot_cont.size_flags_vertical = Control.SIZE_EXPAND_FILL
		self.add_child(slot_cont)

	# I LOVE GODOT ENGINE!!!!!
	var cap_cont := Control.new()
	cap_cont.size_flags_vertical = Control.SIZE_EXPAND_FILL
	self.add_child(cap_cont)

	for i in range(input_args.size()):
		var input_arg : CardBehaviorArgument = input_args[i]
		self.set_slot_enabled_left(i, true)
		self.set_slot_color_left(i, CardBehaviorArgument.ArgumentColors[input_arg.type])

	for i in range(output_args.size()):
		var output_arg : CardBehaviorArgument = output_args[i]
		self.set_slot_enabled_right(i, true)
		self.set_slot_color_right(i, CardBehaviorArgument.ArgumentColors[output_arg.type])
