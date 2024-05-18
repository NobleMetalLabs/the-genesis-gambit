class_name IStatisticPossessor
extends Identifier
## 統計情報を持つクラスのインターフェース

static func id(node : Node) -> IStatisticPossessor:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	return node.get_node("IStatisticPossessor")

const DEFAULTS : Dictionary = {

}

var _statistic_db : Dictionary = {}

func get_statistic(statistic_name : String) -> Variant:
	return _statistic_db.get(statistic_name, DEFAULTS)

func set_statistic(statistic_name : String, value : Variant) -> void:
	_statistic_db[statistic_name] = value