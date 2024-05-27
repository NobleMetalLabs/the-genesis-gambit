extends Node

func _ready() -> void:
	var id := IStatisticPossessor.new()
	id.set_statistic("health", 100)
	var new_id := IStatisticPossessor.new()
	new_id.copy(id)
	print(new_id.get_statistic("health")) # prints 100
