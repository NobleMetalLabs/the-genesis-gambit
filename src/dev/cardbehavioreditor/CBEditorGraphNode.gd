class_name CBEditorGraphNode
extends GraphNode

var node_internal : CardBehaviorNodeInstance

func _init(_node_internal : CardBehaviorNodeInstance, _rect : Rect2) -> void:
	self.node_internal = _node_internal
	self.position_offset = _rect.position
	self.size = _rect.size

	self.title = _node_internal.config.name
	self.resizable = true

	print(_node_internal)
	print(_node_internal.config)
	print(_node_internal.config.input_args)
	print(_node_internal.config.output_args)

	_setup_graphnode()

func _setup_graphnode() -> void:
	_setup_outputs()
	_setup_options()
	_setup_inputs()

	# I LOVE GODOT ENGINE!!!!!
	var cap_cont := Control.new()
	cap_cont.size_flags_vertical = Control.SIZE_EXPAND_FILL
	self.add_child(cap_cont)

func _setup_meta() -> void:
	pass

func __new_label() -> Label:
	var label := Label.new()
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

func _setup_inputs() -> void:
	var input_args : Array[CardBehaviorArgument] = node_internal.config.input_args
	var index_offset : int = self.get_child_count()
	for i in range(input_args.size()):
		var input_label : Label = __new_label()
		input_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		input_label.text = input_args[i].name
		self.add_child(input_label)

		var input_arg : CardBehaviorArgument = input_args[i]
		self.set_slot_enabled_left(index_offset + i, true)
		self.set_slot_type_left(index_offset + i, input_arg.type)
		self.set_slot_color_left(index_offset + i, CardBehaviorArgument.ArgumentColors[input_arg.type])

func _setup_options() -> void:
	pass

func _setup_outputs() -> void:
	var index_offset : int = self.get_child_count()
	var output_args : Array[CardBehaviorArgument] = node_internal.config.output_args
	for i in range(output_args.size()):
		var output_label : Label = __new_label()
		output_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		output_label.text = output_args[i].name
		self.add_child(output_label)

		var output_arg : CardBehaviorArgument = output_args[i]
		self.set_slot_enabled_right(index_offset + i, true)
		self.set_slot_type_right(index_offset + i, output_arg.type)
		self.set_slot_color_right(index_offset + i, CardBehaviorArgument.ArgumentColors[output_arg.type])

