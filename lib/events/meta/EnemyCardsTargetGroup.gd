class_name EnemyCardsTargetGroup
extends FriendlyCardsTargetGroup

func does_group_contain(target : Object) -> bool:
	if target is Player:
		return target != player
	elif target is ICardInstance:
		return target.owner != player
	else:
		return false
