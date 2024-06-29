class_name EffectResolver

var effect_list : Array[Effect] :
	get:
		var effects : Array[Effect] = []
		for requester : Object in effects_by_requester.keys():
			effects.append_array(effects_by_requester[requester])
		return effects

var effects_by_requester : Dictionary = {} # [Object, Array[Effect]]

var already_processed_actions : Array[Action] = []

func request_effect(effect : Effect) -> void:
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
	var requesters_existing_effects : Array[Effect] = effects_by_requester[requester]
	for effect : Effect in requesters_existing_effects.duplicate():
		if effect.has_method("resolve"):
			effect.resolve(self)
		else:
			push_warning("Error: Effect '%s' does not have a resolve method." % [effect])
		effect.resolve_status = Effect.ResolveStatus.RESOLVED
		remove_effect(effect)

func resolve_effects(gamefield_state : GamefieldState) -> void:
	#process all actions
	var action_queue : Array[Action] = AuthoritySourceProvider.authority_source.action_queue.duplicate()
	for action : Action in action_queue:
		#resolve existing effects
		var has_existing_effects : bool = effects_by_requester.has(action)
		if has_existing_effects:
			resolve_existing_effects_of_requester(action)
		else:
			#request new effects
			if action in already_processed_actions: # dont if it did already
				already_processed_actions.erase(action)
				AuthoritySourceProvider.authority_source.action_queue.erase(action)
				continue
			var effect : Effect = action.to_effect()
			effect.requester = action
			self.request_effect(effect)
			already_processed_actions.append(action)
		
	#process all cards
	for card : ICardInstance in gamefield_state.cards:
		if card == null:
			push_error("Card is somehow fucking null.")
			print(gamefield_state.cards)
			continue
		#resolve existing effects
		resolve_existing_effects_of_requester(card)
		if card.is_queued_for_deletion(): continue
		#request new effects
		card.logic.process(gamefield_state, self) #TODO: Should a cache / interop be provided here?
