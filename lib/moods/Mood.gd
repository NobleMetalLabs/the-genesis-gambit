class_name Mood
extends RefCounted

var source : ICardInstance

static func invert_effect(effect : Mood.MoodEffect) -> Mood.MoodEffect:
	match effect:
		Mood.MoodEffect.EXPOSITIVE:
			return Mood.MoodEffect.EXNEGATIVE
		Mood.MoodEffect.POSITIVE:
			return Mood.MoodEffect.NEGATIVE
		Mood.MoodEffect.NEGATIVE:
			return Mood.MoodEffect.POSITIVE
		_:
			return Mood.MoodEffect.EXPOSITIVE

enum MoodEffect {
	EXPOSITIVE,
	POSITIVE,
	NEGATIVE,
	EXNEGATIVE,
}

