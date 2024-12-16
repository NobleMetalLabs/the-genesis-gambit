class_name Event
extends RefCounted

var event_type : StringName
var has_failed := false

func _init() -> void:
	return

func get_subject() -> Object:
	var result : Object = null
	if self.get("card") != null: result = self.card
	elif self.get("player") != null: result = self.player
	elif self.get("subject") != null: result = self.subject
	return result

static func get_event_property_names_of_cards(event : Event) -> Array[StringName]:
	var property_list : Array[Dictionary] = event.get_property_list()
	var properties_that_are_cards : Array[Dictionary] = property_list.filter(
		func properties_that_are_cards(prop_dict : Dictionary) -> bool: 
			return prop_dict["class_name"] == "ICardInstance"
	)
	var property_names : Array[StringName] = []
	property_names.assign(properties_that_are_cards.map(
		func extract_property_name(prop_dict : Dictionary) -> StringName:
			return prop_dict["name"]
	))
	return property_names
