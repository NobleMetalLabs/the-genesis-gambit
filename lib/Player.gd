class_name Player
extends Node

var hand : Array[CardMetadata] = []

func _ready():
	AuthoritySourceProvider.provider.reflect_action.connect(_handle_player_action)

func _handle_player_action(action : Dictionary) -> void:
	if action["type"] != "hand": return
	match action["action"]:
		"add_card":
			var card_meta = CardDB.get_card_by_id(action["data"]["metadata_id"])
			hand.append(card_meta)
		"burn_hand":
			burn_hand()
		_:
			pass