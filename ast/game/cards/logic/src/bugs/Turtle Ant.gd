extends CardLogic

static var description : StringName = "Supported creature is protected. Attacks made against the creature deal half damage."

var last_supported_creature : ICardInstance

func HANDLE_TARGETED(event : TargetedEvent) -> void:
	if last_supported_creature != null:
		last_supported_creature.logic.WAS_ATTACKED.disconnect(HANDLE_WAS_ATTACKED_ON_SUPPORTED)
	super(event)

func HANDLE_SUPPORTED(event : SupportedEvent) -> void:
	last_supported_creature = event.who
	last_supported_creature.logic.WAS_ATTACKED.connect(HANDLE_WAS_ATTACKED_ON_SUPPORTED)
	super(event)

func HANDLE_WAS_ATTACKED_ON_SUPPORTED(event : WasAttackedEvent) -> void:
	event.damage /= 2
	print("avled")

#extends CardLogic
#
#static var description : StringName = "Targeted creature is protected. Attacks made against the creature deal half damage."
#
#func process(_backend_objects : BackendObjectCollection, _effect_resolver : EffectResolver) -> void:
	#var my_stats := IStatisticPossessor.id(instance_owner)
	#if my_stats.get_statistic(Genesis.Statistic.HAS_TARGET):
		#var target : ICardInstance = my_stats.get_statistic(Genesis.Statistic.TARGET)
		#if my_stats.get_statistic(Genesis.Statistic.WAS_JUST_ATTACKED):
			#for effect in _effect_resolver.effect_list:
				#if not effect is CreatureAttackEffect: continue
				#effect = effect as CreatureAttackEffect
				#if not effect.target == target: continue
				#effect.damage = effect.damage / 2
