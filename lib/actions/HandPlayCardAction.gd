class_name HandPlayCardAction
extends HandAction

var card_in_hand_uid : int
var position : Vector2

static func setup(card : ICardInstance, at_position : Vector2) -> HandPlayCardAction:
	var hpca := HandPlayCardAction.new()
	hpca.card_in_hand_uid = UIDDB.uid(card)
	hpca.position = at_position
	return hpca

func _init() -> void: pass

func _to_string() -> String:
	return "HandPlayCardAction(%s,%s,%s)" % [self.player_peer_id, UIDDB.object(card_in_hand_uid), self.position]

# func to_effect() -> HandRemoveCardEffect:
# 	var card_instance : ICardInstance = UIDDB.object(card_in_hand_uid)
# 	IStatisticPossessor.id(card_instance).set_statistic(Genesis.Statistic.POSITION, position)
# 	return HandRemoveCardEffect.new(card_instance, card_instance.player, card_instance, Genesis.LeaveHandReason.PLAYED)
