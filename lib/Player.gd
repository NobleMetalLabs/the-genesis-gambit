class_name Player
extends Node

var hand : Array[CardMetadata] = []

func _ready() -> void:
	AuthoritySourceProvider.provider.reflect_action.connect(_handle_player_action)

func _handle_player_action(action : Action) -> void:
	if not action is PlayerAction: return

	if action is HandAddCardAction:
		var add_action : HandAddCardAction = action as HandAddCardAction
		var card_meta : CardMetadata = CardDB.get_card_by_id(add_action.card_metadata_id)
		hand.append(card_meta)

	if action is HandBurnHandAction:
		var num_cards : int = hand.size()
		hand.clear()
		for i in range(num_cards):
			AuthoritySourceProvider.provider.request_action(
				HandAddCardAction.new(self, false, true, 0)
			)