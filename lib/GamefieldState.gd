class_name GamefieldState
extends Resource

var players : Array[Player]

var cards : Array[ICardInstance] : 
	get : 
		var out : Array[ICardInstance] = []
		for p in players:
			for c in p.cards_in_hand:
				out.append(ICardInstance.id(c))
			for c in p.cards_on_field:
				out.append(ICardInstance.id(c))
			for c in p.deck.get_cards():
				out.append(ICardInstance.id(c))
		return out

func _init(_players : Array[Player]) -> void:
	self.players = _players
