class_name FriendlyCardsTargetGroup
extends BaseTargetGroup

var player : Player

func _init(_player : Player) -> void:
	self.player = _player

func does_group_contain(target : Object) -> bool:
	if target is Player:
		return target == player
	elif target is ICardInstance:
		return target.owner == player
	else:
		return false

func _to_string() -> String:
	return "FriendlyCardsTargetGroup[%s]" % player
