class_name Identifier
extends Node

func copy(existing : Identifier) -> Identifier:
	var property_list : Array[Dictionary] = existing.get_property_list()
	property_list.reverse()
	for property in property_list:
		var property_name : StringName = property["name"]
		if property_name.ends_with(".gd"): continue
		if property_name.is_empty(): continue
		if property_name == "Script": break
		self.set(property_name, existing.get(property_name))
	return self

func get_object() -> Node:
	return self.get_parent()

func _to_string() -> String:
	var owner_string : String = self.get_object().to_string()
	var card : ICardInstance = ICardInstance.id(self)
	# if card != null:
	# 	var card_string : String = card.to_string()
	# 	var regex := RegEx.new()
	# 	regex.compile("(?<=\\().*?(?=\\))")
	# 	owner_string = regex.search(card_string).strings[0]
	return "%s<%s>" % [self.name, owner_string]
	
