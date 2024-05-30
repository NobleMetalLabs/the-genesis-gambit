class_name HandAddCardEffect
extends HandEffect

var from_deck : bool
var specific_card : bool
var card_metadata_id : int

func _init(_player : Player, _from_deck : bool = true, _specific_card : bool = false, _card_metadata_id : int = 0) -> void:
	self.player = _player
	self.from_deck = _from_deck
	self.specific_card = _specific_card
	self.card_metadata_id = _card_metadata_id

func _to_string() -> String:
	return "HandAddCardEffect(%s,%s,%s,%s)" % [self.player, self.from_deck, self.specific_card, self.card_metadata_id]