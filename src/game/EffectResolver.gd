class_name EffectResolver
extends RefCounted

var effect_list : Array[Effect] :
	get:
		var effects : Array[Effect] = []
		for requester : Object in effects_by_requester.keys():
			effects.append_array(effects_by_requester[requester])
		return effects

var effects_by_requester : Dictionary = {} # [Object, Array[Effect]]

var yet_to_process_actions : Array[Action] = []
var already_processed_actions : Array[Action] = []

func _init() -> void:
	AuthoritySourceProvider.authority_source.reflect_action.connect(
		func(action : Action) -> void:
			yet_to_process_actions.append(action)
	)

func request_effect(effect : Effect) -> void:
	# print("%s : Requesting effect '%s'." % [MultiplayerManager.get_peer_id(), effect])
	var requester_exists : bool = effects_by_requester.has(effect.requester)
	if not requester_exists:
		effects_by_requester[effect.requester] = [effect] as Array[Effect]
	else:
		var existing_requests : Array[Effect] = effects_by_requester[effect.requester]
		existing_requests.append(effect)
	effect.resolve_status = Effect.ResolveStatus.REQUESTED

func remove_effect(effect : Effect) -> void:
	var requester_exists : bool = effects_by_requester.has(effect.requester)
	if not requester_exists:
		push_error("Error: Attempted to remove an effect that is not in the list.")
		return
	var requesters_existing_effects : Array[Effect] = effects_by_requester[effect.requester]
	requesters_existing_effects.erase(effect)
	if requesters_existing_effects.size() == 0:
		effects_by_requester.erase(effect.requester)

func resolve_existing_effects_of_requester(requester : Object) -> void:
	var requester_exists : bool = effects_by_requester.has(requester)
	if not requester_exists: 
		return
	var requesters_existing_effects : Array[Effect] = effects_by_requester[requester].duplicate()
	# print("%s : Resolving effects for requester '%s': %s." % [MultiplayerManager.get_peer_id(), requester, requesters_existing_effects])
	for effect : Effect in requesters_existing_effects:
		if effect.has_method("resolve"):
			# print("%s : Resolving effect '%s'." % [MultiplayerManager.get_peer_id(), effect])
			effect.resolve(self)
		else:
			push_warning("Error: Effect '%s' does not have a resolve method." % [effect])
		effect.resolve_status = Effect.ResolveStatus.RESOLVED
		remove_effect(effect)

func resolve_effects(backend_state : MatchBackendState) -> void:
	#process all actions
	var action_queue : Array[Action] = yet_to_process_actions.duplicate() + already_processed_actions.duplicate()
	for action : Action in action_queue:
		#resolve existing effects
		var has_existing_effects : bool = effects_by_requester.has(action)
		if has_existing_effects:
			resolve_existing_effects_of_requester(action)
			if not action in already_processed_actions:
				already_processed_actions.append(action)
			yet_to_process_actions.erase(action)
		else:
			#request new effects
			if action in already_processed_actions: # dont if it did already
				already_processed_actions.erase(action)
				continue
			var effect : Effect = action.to_effect()
			effect.requester = action
			self.request_effect(effect)
		
	#process all cards
	for card : ICardInstance in backend_state.cards:
		if card == null:
			push_error("Card is somehow fucking null.")
			continue
		#resolve existing effects
		resolve_existing_effects_of_requester(card)
		if card.is_queued_for_deletion(): continue
		#request new effects
		card.logic.process(backend_state, self) #TODO: Should a cache / interop be provided here?
