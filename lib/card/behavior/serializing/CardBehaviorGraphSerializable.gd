@icon("res://lib/cardbehavior/CardBehaviorGraph.png")
class_name CardBehaviorGraphSerializable
extends Resource

var description : String = ""
var nodes : Array[Dictionary] = []
var edges : Array[Dictionary] = []

static func serialize(behavior : CardBehaviorGraph) -> CardBehaviorGraphSerializable:
	var cbgs := CardBehaviorGraphSerializable.new()
	cbgs.description = behavior.description
	for node in behavior.nodes:
		var node_dict : Dictionary = Utils.object_to_dict(node, true)
		var config_name : StringName = node_dict["config"]["name"]
		node_dict["config"] = config_name
		cbgs.nodes.append(node_dict)
	for edge in behavior.edges:
		var edge_dict : Dictionary = Utils.object_to_dict(edge)
		edge_dict["start_node"] = behavior.nodes.find(edge.start_node)
		edge_dict["end_node"] = behavior.nodes.find(edge.end_node)
		cbgs.edges.append(edge_dict)
	return cbgs

static func from_dict(dict : Dictionary) -> CardBehaviorGraphSerializable:
	var cbgs := CardBehaviorGraphSerializable.new()
	cbgs.description = dict["description"]
	cbgs.nodes.assign(dict["nodes"])
	cbgs.edges.assign(dict["edges"])
	return cbgs

func deserialize() -> CardBehaviorGraph:
	var behavior := CardBehaviorGraph.new()
	behavior.description = description
	for node_dict in nodes:
		var config := CardBehaviorNode.load_node(node_dict["config"])
		var node := CardBehaviorNodeInstance.new(config, node_dict["argument_values"])
		behavior.nodes.append(node)
	for edge_dict in edges:
		var edge := CardBehaviorEdge.new(
			behavior.nodes[edge_dict["start_node"]],
			edge_dict["start_port"],
			behavior.nodes[edge_dict["end_node"]],
			edge_dict["end_port"]
		)
		behavior.edges.append(edge)
	return behavior

