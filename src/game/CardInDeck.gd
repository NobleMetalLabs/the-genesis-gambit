class_name CardInDeck
extends Node

func _init(provided_identifiers : Array[Identifier]) -> void:
	for identifier in provided_identifiers:
		var old_parent : Node = identifier.get_parent()
		if old_parent != null: 
			identifier.reparent(self)
			old_parent.add_child(identifier.clone())
		else: 
			self.add_child(identifier)

	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is ICardInstance):
		push_error("CardInDeck must be provided with ICardInstance identifier.")
		return
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IStatisticPossessor): 
		self.add_child(IStatisticPossessor.new())
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IMoodPossessor): 
		self.add_child(IMoodPossessor.new())

	self.name = "CardInDeck"

func _to_string() -> String:
	return "CardInDeck<%s>" % ICardInstance.id(self)