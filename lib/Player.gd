class_name Player
extends Node

var hand : Array[CardMetadata] = []

func _ready() -> void:
	AuthoritySourceProvider.provider.reflect_action.connect(_handle_player_action)

func _handle_player_action(action : Dictionary) -> void:
	if action["type"] != "hand": return
	match action["action"]:
		"add_card":
			var card_meta : CardMetadata = CardDB.get_card_by_id(action["data"]["metadata_id"])
			hand.append(card_meta)
			print(hand.size())
		"burn_hand":
			var num_cards : int = hand.size()
			print(num_cards)
			hand.clear()
			print(hand.size())
			for i in range(num_cards):
				AuthoritySourceProvider.provider.call_deferred(
					"request_action",
					{
						"type" : "hand",
						"action" : "add_card",
						"data" : {
							"metadata_id" : 0
						}
					}
				)
		_:
			pass
	