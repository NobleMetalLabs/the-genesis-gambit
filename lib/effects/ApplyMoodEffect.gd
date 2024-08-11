class_name ApplyMoodEffect
extends MoodEffect

var mood : Mood

func _init(_requester : Object, _target : IMoodPossessor, _mood : Mood) -> void:
	self.requester = _requester
	self.target = _target
	self.mood = _mood

func _to_string() -> String:
	return "ApplyMoodEffect(%s,%s)" % [self.target, self.mood]

func resolve(_effect_resolver : EffectResolver) -> void:
	if IStatisticPossessor.id(self.target).get_statistic(Genesis.Statistic.CAN_HAVE_MOODS) == false:
		self.resolve_status = ResolveStatus.FAILED
		return
	
	var is_bored : bool = false
	var bored_mood : Mood = null
	for checking_mood : Mood in target.get_moods():
		if checking_mood is BoredomMood: 
			bored_mood = checking_mood
			is_bored = true
			break

	if mood is BoredomMood:
		if is_bored:
			_effect_resolver.request_effect(CreatureLeavePlayEffect.new(
				self.requester,
				ICardInstance.id(target),
				ICardInstance.id(target),
				Genesis.LeavePlayReason.DIED
			))
		if target.get_moods().size() > 0:
			return
	else:
		if is_bored:
			_effect_resolver.request_effect(RemoveMoodEffect.new(
				self.requester,
				target,
				bored_mood
			))
			
	target.apply_mood(mood)
