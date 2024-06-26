class_name CreatureLeavePlayEffect
extends CreatureEffect

var source : ICardInstance
var reason : Genesis.LeavePlayReason

func _init(_requester : Object, _creature : ICardInstance, _source : ICardInstance, _reason : Genesis.LeavePlayReason = Genesis.LeavePlayReason.DIED) -> void:
	self.requester = _requester
	self.creature = _creature
	self.source = _source
	self.reason = _reason

#TODO: give this effect a destination enum that handles creates the *AddCardEffect instead of those effects being made and forced to do cleanup

func _to_string() -> String:
	return "CreatureLeavePlayEffect(%s,%s,%s)" % [self.creature, self.source, self.reason]

func resolve(effect_resolver : EffectResolver) -> void:
	var player_owner : Player = ICardInstance.id(self.creature).player
	effect_resolver.request_effect(DeckAddCardEffect.new(
		self, player_owner, ICardInstance.id(self.creature)
	))
