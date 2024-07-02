class_name GamefieldState
extends Resource

var players : Array[Player]

var cards : Array[ICardInstance] : 
	get : 
		var out : Array[ICardInstance] = []
		for p in players:
			for card in p.cards_in_hand:
				if is_instance_valid(card):
					out.append(ICardInstance.id(card))
			for card in p.cards_on_field:
				if is_instance_valid(card):
					out.append(ICardInstance.id(card))
			for card in p.deck.get_cards():
				if is_instance_valid(card):
					out.append(ICardInstance.id(card))
		return out

func _init(_players : Array[Player]) -> void:
	self.players = _players
