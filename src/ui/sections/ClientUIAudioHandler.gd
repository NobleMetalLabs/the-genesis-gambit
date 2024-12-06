class_name ClientUIAudioHandler
extends RefCounted

var client_ui : ClientUI

func _init(_client_ui : ClientUI) -> void:
	self.client_ui = _client_ui

	var args := Array(OS.get_cmdline_args())
	if args.has("-server"):
		for bus_idx : int in range(0, AudioServer.bus_count):
			AudioServer.set_bus_mute(bus_idx, true)

# func handle_effect_audio(effect : Effect) -> void:
# 	if effect.resolve_status == Effect.ResolveStatus.FAILED: return
# 	if effect is CreatureEffect:
# 		var creature_frontend : CardFrontend = client_ui.get_card_frontend(effect.creature)
# 		var creature_position : Vector2 = Vector2.ZERO
# 		if creature_frontend != null: 
# 			creature_position = creature_frontend.global_position

# 		if effect is CreatureActivateEffect:
# 			effect = effect as CreatureActivateEffect
# 			AudioDispatcher.dispatch_positional_audio(
# 				creature_position, "laser"
# 			)

# 		elif effect is CreatureAttackEffect:
# 			effect = effect as CreatureAttackEffect
# 			if effect.damage <= 0: return
# 			AudioDispatcher.dispatch_positional_audio(
# 				creature_position, "hitslash"
# 			)

# 			var target_frontend : CardFrontend = client_ui.get_card_frontend(effect.target)
# 			if target_frontend == null: 
# 				return
# 			var target_position : Vector2 = target_frontend.global_position
# 			var hit_delay : Tween = client_ui.get_tree().create_tween()
# 			hit_delay.tween_interval(randf_range(0.2, 0.8))
# 			hit_delay.tween_callback(
# 				AudioDispatcher.dispatch_positional_audio.bind(
# 					target_position, "hitheavy"
# 				)
# 			)

# 			var target_stats := IStatisticPossessor.id(effect.target)
# 			if target_stats == null: return
# 			var curr_health : float = target_stats.get_statistic(Genesis.Statistic.HEALTH)
# 			var max_health : float = effect.target.metadata.health
# 			var attack_damage : float = effect.damage
# 			var is_low_health : bool = curr_health / max_health < 0.25
# 			var was_low_health : bool = curr_health + attack_damage / max_health < 0.25
# 			if not was_low_health and is_low_health:
# 				AudioDispatcher.dispatch_positional_audio(
# 					target_position, "warning"
# 				)
				
# 		elif effect is CreatureLeavePlayEffect:
# 			effect = effect as CreatureLeavePlayEffect
# 			AudioDispatcher.dispatch_audio(
# 				#creature_position, 
# 				"carddeath"
# 			)

# 		elif effect is CreatureSpawnEffect:
# 			effect = effect as CreatureSpawnEffect
# 			AudioDispatcher.dispatch_positional_audio(
# 				creature_position, "cardplace"
# 			)

# 		elif effect is CreatureTargetEffect:
# 			effect = effect as CreatureTargetEffect
# 			AudioDispatcher.dispatch_positional_audio(
# 				creature_position, "equip"
# 			)

# 	elif effect is HandEffect:
# 		if effect is HandBurnHandEffect:
# 			AudioDispatcher.dispatch_audio("burnhand").volume_db = -5
		
