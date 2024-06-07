class_name CBEditorGraphNode
extends GraphNode

var targeted : bool :
	get: return targeted
	set(value): 
		targeted = value
		#self.overlay = GraphNode.OVERLAY_POSITION if value else GraphNode.OVERLAY_DISABLED
		push_navigation_direction("NONE")

var targeted_index : int
var targeting_dir : StringName

@export var node : CardBehaviorNode : 
	get:
		return node
	set(value):
		node = value
		node.setup(self)

func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	event = event as InputEventMouseButton
	if event.double_click:
		node_targeted.emit(self)

func push_navigation_direction(dir : StringName) -> void:
	if dir == targeting_dir:
		_advance_selected_idx()
	else:
		_new_targeting_dir(dir)

func _advance_selected_idx() -> void:
	var str_dir : String = ""
	match(targeting_dir.to_upper()):
		"INPUT": str_dir = "left"
		"OUTPUT": str_dir = "right"
		_: return
	self.call("set_slot_color_%s" % [str_dir], targeted_index, Color.WHITE)
	targeted_index += 1
	if not self.call("is_slot_enabled_%s" % [str_dir], targeted_index): 
		targeted_index = 0
	self.call("set_slot_color_%s" % [str_dir], targeted_index, Color.YELLOW)

func _new_targeting_dir(dir : StringName) -> void:
	for idx in range(0, self.get_child_count()):
		self.set_slot_color_left(idx, Color.WHITE)
		self.set_slot_color_right(idx, Color.WHITE)
	targeted_index = 0
	match(dir.to_upper()):
		"INPUT": self.set_slot_color_left(targeted_index, Color.YELLOW)
		"OUTPUT": self.set_slot_color_right(targeted_index, Color.YELLOW)
	targeting_dir = dir

signal node_targeted(node : CBEditorGraphNode)