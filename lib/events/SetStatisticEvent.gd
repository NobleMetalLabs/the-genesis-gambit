class_name SetStatisticEvent
extends Event

var subject : Object
var statistic : Genesis.Statistic
var old_value : Variant
var new_value : Variant

func _init(_subject : Object, _statistic : Genesis.Statistic, _new_value : Variant) -> void:
	self.event_type = "SET_STATISTIC"
	self.subject = _subject
	
	self.statistic = _statistic
	
	self.old_value = IStatisticPossessor.id(subject).get_statistic(statistic)
	self.new_value = _new_value

func _to_string() -> String:
	return "SetStatisticEvent(%s, %s, %s)" % [self.subject, Genesis.Statistic.keys()[statistic], self.new_value]

static func modify(_subject : Object, _statistic : Genesis.Statistic, delta : int) -> SetStatisticEvent:
	var value : int = IStatisticPossessor.id(_subject).get_statistic(_statistic)
	return SetStatisticEvent.new(_subject, _statistic, value + delta)
