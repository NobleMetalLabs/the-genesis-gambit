class_name IMoodPossessor
extends Identifier

static func id(node : Node) -> IMoodPossessor:
	if node == null: return null
	if node is Identifier:
		node = node.get_object()
	return node.get_node("IMoodPossessor")

var _active_moods : Array[Mood] = []

func apply_mood(mood : Mood) -> void:
	_active_moods.append(mood)

func remove_mood(mood : Mood) -> void:
	_active_moods.erase(mood)

func _get_statistic(statistic_name : String, base_value : Variant) -> Variant:
	if typeof(base_value) != TYPE_INT: 
		return base_value
	print("BASED!")
	for mood in _active_moods:
		if not mood is StatisticMood: continue
		mood = mood as StatisticMood
		if mood.statistic == statistic_name:
			match(mood.effect):
				Mood.MoodEffect.EXPOSITIVE:
					base_value *= 2
				Mood.MoodEffect.POSITIVE:
					base_value += 1
				Mood.MoodEffect.NEGATIVE:
					base_value -= 1
				Mood.MoodEffect.EXNEGATIVE:
					base_value /= 2
	return base_value
