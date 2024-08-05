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
	
	if mood is BoredomMood:
		var is_bored : bool = false
		for checking_mood : Mood in target.get_moods():
			if checking_mood is BoredomMood: 
				is_bored = true
				break
		
		if is_bored:
			_effect_resolver.request_effect(CreatureLeavePlayEffect.new(
				self.requester,
				ICardInstance.id(target),
				ICardInstance.id(target),
				Genesis.LeavePlayReason.DIED
			))
			
			
	
	target.apply_mood(mood)
