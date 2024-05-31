class_name EffectResolver

signal reflect_effect(effect : Effect)

var effect_queue : Array[Effect] = []
var effect_by_requester : Dictionary = {} # [Object, Effect]

func _init() -> void:
	pass

func request_effect(effect : Effect) -> void:
	print("Requesting effect: " + str(effect))
	effect_queue.append(effect)
	var requester_exists : bool = effect_by_requester.has(effect.requester)
	#print("Requester exists: " + str(requester_exists))
	if not requester_exists:
		effect_by_requester[effect.requester] = [effect] as Array[Effect]
	else:
		var existing_requests : Array[Effect] = effect_by_requester[effect.requester]
		#print("Existing requests: " + str(existing_requests))
		existing_requests.append(effect)
	#print("Effects by requester: " + str(effect_by_requester))

func remove_effect(effect : Effect) -> void:
	var requester_exists : bool = effect_by_requester.has(effect.requester)
	if not requester_exists:
		push_error("Error: Attempted to remove an effect that doesn't exist.")
		return
	var requesters_existing_effects : Array[Effect] = effect_by_requester[effect.requester]
	requesters_existing_effects.erase(effect)
	if requesters_existing_effects.size() == 0:
		effect_by_requester.erase(effect.requester)

func resolve_effects_of_requester(requester : Object) -> void:
	#print("Resolving effects of requester: " + str(requester))
	var requester_exists : bool = effect_by_requester.has(requester)
	if not requester_exists: 
		print("No effects to resolve for requester: " + str(requester))
		return
	var requesters_existing_effects : Array[Effect] = effect_by_requester[requester]
	for effect : Effect in requesters_existing_effects.duplicate():
		print("Resolving effect: " + str(effect))
		print("Commanding effect to be reflected: " + str(effect))
		self.reflect_effect.emit(effect)
		if effect.has_method("resolve"):
			effect.resolve()
		else:
			push_warning("Error: Effect '%s' does not have a resolve method." % [effect])
		remove_effect(effect)
	print("Effects by requester: " + str(effect_by_requester))

func resolve_effects(gamefield_state : GamefieldState) -> void:
	#process all actions
	for action : Action in AuthoritySourceProvider.authority_source.action_queue:
		print("Processing action: " + str(action))
		resolve_effects_of_requester(action)
		if action == null: continue
		var effect : Effect = action.to_effect()
		effect.requester = action
		self.request_effect(effect)
		var kill_effect : Effect = InvokeCallableEffect.new(
			func() -> void:
				AuthoritySourceProvider.authority_source.action_queue.erase(action)
				action.free()
		)
		kill_effect.requester = action
		self.request_effect(kill_effect)
		
	#process all cards
	for card : ICardInstance in gamefield_state.cards:
		print("Processing card: " + str(card))
		resolve_effects_of_requester(card)
		if card.is_queued_for_deletion(): continue
		card.logic.process(self)
