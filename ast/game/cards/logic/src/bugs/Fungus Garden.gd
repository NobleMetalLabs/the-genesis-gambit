extends CardLogic

static var description : StringName = "Whenever a creature on your field would be subject to Boredom, it instead targets the Fungus Garden, tending it. Every 5 damage the garden receives gives it a charge of fungus. Activate: Spawn a copy of the creature it is targeting."

var damage_count : int = 0

# NOTE: you can duplicate some stuff you probably shouldnt be able to

func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	var my_stats := IStatisticPossessor.id(instance_owner)
	if my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD) == false: return
	
	for friendly_creature : ICardInstance in instance_owner.player.cards_on_field:
		var creature_moods := IMoodPossessor.id(friendly_creature)
		for mood in creature_moods.get_moods():
			if mood is BoredomMood:
				creature_moods.remove_mood(mood)
				_effect_resolver.request_effect(
					CreatureTargetEffect.new(
						instance_owner,
						friendly_creature,
						instance_owner,
					)
				)

	for effect in _effect_resolver.effect_list:
		if effect is CreatureAttackEffect:
			var attack_effect := effect as CreatureAttackEffect
			if attack_effect.target == instance_owner:
				damage_count += attack_effect.damage
				my_stats.modify_statistic(Genesis.Statistic.CHARGES, damage_count / 5)
				damage_count %= 5
				attack_effect.damage = 0
	
	if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		if my_stats.get_statistic(Genesis.Statistic.CHARGES) > 0:
			my_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
			var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
			
			if target == null: return
			if target == instance_owner.player.leader: return
			
			var target_dupe : ICardInstance = Router.backend.create_card(
				target.metadata.id,
				instance_owner.player,
				"Dupe%s-%s" % [
					target.metadata.name,
					AuthoritySourceProvider.authority_source.current_frame_number
				]
			)

			IStatisticPossessor.id(target_dupe).set_statistic(
				Genesis.Statistic.POSITION, IStatisticPossessor.id(target).get_statistic(Genesis.Statistic.POSITION) + Vector2(50, 50))

			_effect_resolver.request_effect(
				CreatureSpawnEffect.new(
					instance_owner,
					target_dupe
				)
			)
