class_name CreatureLeavePlayEffect
extends CreatureEffect

var source : ICardInstance
var reason : Genesis.LeavePlayReason

func _init(_creature : CardOnField, _source : ICardInstance, _reason : Genesis.LeavePlayReason = Genesis.LeavePlayReason.SACRIFICED) -> void:
	self.creature = _creature
	self.source = _source
	self.reason = _reason

func _to_string() -> String:
	return "CreatureLeavePlayEffect(%s,%s,%s)" % [self.creature, self.source, self.reason]

func resolve(effect_resolver : EffectResolver) -> void:
	var player_owner : Player = ICardInstance.id(self.creature).player
	var deck_add_effect := DeckAddCardEffect.new(
		player_owner, ICardInstance.id(self.creature)
	)
	deck_add_effect.requester = self.requester
	effect_resolver.request_effect(deck_add_effect)
