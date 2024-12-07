class_name StatisticMood
extends Mood

var statistic : Genesis.Statistic
var effect : Mood.MoodEffect
var amount : int

func _init(_source : ICardInstance, _statistic : Genesis.Statistic, _effect : Mood.MoodEffect, _amount : int = 1) -> void:
	self.statistic = _statistic
	self.effect = _effect
	self.source = _source
	self.amount = _amount

func _to_string() -> String:
	return "StatisticMood(<%s>, %s, %s, %d)" % [self.source, Genesis.Statistic.keys()[self.statistic], Mood.MoodEffect.keys()[self.effect], self.amount]

# Helpers

const MOOD_NAMES : Array[StringName] = [
	"JOLLY",
	"HAPPY",
	"SAD",
	"SICK",
	"RAGE",
	"ANGRY",
	"WEAK",
	"DEPRESSED",
	"ENLIGHTENED",
	"QUICK",
	"SLOW",
	"STUPID",
]

static func FROM_NAME(_source : ICardInstance, name : String, _amount : int = 1) -> StatisticMood:
	match name:
		"JOLLY": return JOLLY(_source, _amount)
		"HAPPY": return HAPPY(_source, _amount)
		"SAD": return SAD(_source, _amount)
		"SICK":	return SICK(_source, _amount)
		"RAGE":	return RAGE(_source, _amount)
		"ANGRY": return ANGRY(_source, _amount)
		"WEAK":	return WEAK(_source, _amount)
		"DEPRESSED": return DEPRESSED(_source, _amount)
		"ENLIGHTENED": return ENLIGHTENED(_source, _amount)
		"QUICK": return QUICK(_source, _amount)
		"SLOW": return SLOW(_source, _amount)
		"STUPID": return STUPID(_source, _amount)
		_: return null

# Health
static func JOLLY(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.HEALTH, Mood.MoodEffect.EXPOSITIVE, _amount)

static func HAPPY(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.HEALTH, Mood.MoodEffect.POSITIVE, _amount)

static func SAD(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.HEALTH, Mood.MoodEffect.NEGATIVE, _amount)

static func SICK(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.HEALTH, Mood.MoodEffect.EXNEGATIVE, _amount)

# Strength
static func RAGE(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.STRENGTH, Mood.MoodEffect.EXPOSITIVE, _amount)

static func ANGRY(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.STRENGTH, Mood.MoodEffect.POSITIVE, _amount)

static func WEAK(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.STRENGTH, Mood.MoodEffect.NEGATIVE, _amount)

static func DEPRESSED(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.STRENGTH, Mood.MoodEffect.EXNEGATIVE, _amount)

# Speed
static func ENLIGHTENED(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.SPEED, Mood.MoodEffect.EXPOSITIVE, _amount)

static func QUICK(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.SPEED, Mood.MoodEffect.POSITIVE, _amount)

static func SLOW(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.SPEED, Mood.MoodEffect.NEGATIVE, _amount)

static func STUPID(_source : ICardInstance, _amount : int = 1) -> StatisticMood:
	return StatisticMood.new(_source, Genesis.Statistic.SPEED, Mood.MoodEffect.EXNEGATIVE, _amount)
