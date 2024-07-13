class_name HandPlayCardAction
extends HandAction

var card_in_hand_uid : int

static func setup(card : CardInHand) -> HandPlayCardAction:
	var hpca := HandPlayCardAction.new()
	hpca.card_in_hand_uid = UIDDB.uid(ICardInstance.id(card))
	return hpca

func _init() -> void: pass

func _to_string() -> String:
	return "HandPlayCardAction(%s,%s)" % [self.player_peer_id, UIDDB.object(card_in_hand_uid)]

func to_effect() -> HandRemoveCardEffect:
	var card_instance : ICardInstance = UIDDB.object(card_in_hand_uid)
	var card_obj : CardInHand = card_instance.get_object()
	return HandRemoveCardEffect.new(card_instance, card_instance.player, card_obj, Genesis.LeaveHandReason.PLAYED)
